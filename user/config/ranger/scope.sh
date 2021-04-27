#!/usr/bin/env bash
# shellcheck disable=SC2181

set -o noclobber -o noglob -o nounset -o pipefail
IFS=$'\n'

#
# ─── INTRODUCTION ───────────────────────────────────────────────────────────────
#

# If the option `use_preview_script` is set to `true`,
# then this script will be called and its output will be displayed in ranger.
# ANSI color codes are supported.
# STDIN is disabled, so interactive scripts won't work properly

# This script is considered a configuration file and must be updated manually.
# It will be left untouched if you upgrade ranger.

# Because of some automated testing we do on the script #'s for comments need
# to be doubled up. Code that is commented out, because it's an alternative for
# example, gets only one #.

# Meanings of exit codes:
# code | meaning    | action of ranger
# -----+------------+-------------------------------------------
# 0    | success    | Display stdout as preview
# 1    | no preview | Display no preview at all
# 2    | plain text | Display the plain content of the file
# 3    | fix width  | Don't reload when width changes
# 4    | fix height | Don't reload when height changes
# 5    | fix both   | Don't ever reload
# 6    | image      | Display the image `$IMAGE_CACHE_PATH` points to as an image preview
# 7    | image      | Display the file directly as an image

#
# ─── SCRIPT ARGUMENTS ───────────────────────────────────────────────────────────
#

# Full path of the highlighted file
FILE_PATH="$1"

# Width of the preview pane (number of fitting characters)
PV_WIDTH="$2"

# Height of the preview pane (number of fitting characters)
PV_HEIGHT="$3"

# Full path that should be used to cache image preview
IMAGE_CACHE_PATH="$4"

# 'True' if image previews are enabled, 'False' otherwise.
PV_IMAGE_ENABLED="$5"

#
# ─── SETTINGS ───────────────────────────────────────────────────────────────────
#

# Size of the preview if there are multiple options or it has to be
# rendered from vector graphics. If the conversion program allows
# specifying only one dimension while keeping the aspect ratio, the width
# will be used.
DEFAULT_SIZE="1920x1080"
HIGHLIGHT_SIZE_MAX=262143  # 256KiB
HIGHLIGHT_OPTIONS="--replace-tabs=8 --style=pablo"
OPENSCAD_IMGSIZE="1000,1000"
OPENSCAD_COLORSCHEME="Tomorrow Night"
PYGMENTIZE_STYLE=autumn

handle_image() {
	local mimetype="$1"
	local fileExtension="$2"

	case "$mimetype" in
	# SVG
	image/svg|image/svg+xml)
		convert -- "$FILE_PATH" "$IMAGE_CACHE_PATH" && exit 6
		bat "$FILE_PATH" && exit 6
		;;

	# DjVu
	image/vnd.djvu)
		ddjvu -format=tiff -quality=90 -page=1 -size="$DEFAULT_SIZE" \
				- "$IMAGE_CACHE_PATH" < "$FILE_PATH" \
			&& exit 6
		exit 1
		;;

	# Image
	image/*)
		local orientation
		orientation="$(identify -format '%[EXIF:Orientation]\n' -- "$FILE_PATH")"

		# If orientation data is present and the image actually
		# needs rotating ("1" means no rotation), rotate
		# the image according to EXIF data
		if [[ -n "$orientation" && "$orientation" != 1 ]]; then
			convert -- "$FILE_PATH" -auto-orient "$IMAGE_CACHE_PATH" && exit 6
		fi

		# `w3mimgdisplay` will be called for all images (unless overriden
		# as above), but might fail for unsupported types.
		exit 7
		;;

	# Video
	video/*)
		# Thumbnail
		ffmpegthumbnailer -i "$FILE_PATH" -o "$IMAGE_CACHE_PATH" -s 0 && exit 6
		exit 1
		;;

	# PDF
	application/pdf)
		pdftoppm -f 1 -l 1 \
				-scale-to-x "${DEFAULT_SIZE%x*}" \
				-scale-to-y -1 \
				-singlefile \
				-jpeg -tiffcompression jpeg \
				-- "$FILE_PATH" "${IMAGE_CACHE_PATH%.*}" \
			&& exit 6
		exit 1
		;;

	# ePub, MOBI, FB2 (using Calibre)
	application/epub+zip|application/x-mobipocket-ebook|\
	application/x-fictionbook+xml)
		# ePub (using https://github.com/marianosimone/epub-thumbnailer)
		epub-thumbnailer "${FILE_PATH}" "${IMAGE_CACHE_PATH}" \
				"${DEFAULT_SIZE%x*}" \
			&& exit 6

		ebook-meta --get-cover="${IMAGE_CACHE_PATH}" -- "${FILE_PATH}" \
				>/dev/null \
			&& exit 6

		exit 1
		;;

	# Font
	application/font*|application/*opentype)
		preview_png="/tmp/$(basename "${IMAGE_CACHE_PATH%.*}").png"
		if fontimage -o "$preview_png" \
			--pixelsize "120" \
			--fontname \
			--pixelsize "80" \
			--text "  ABCDEFGHIJKLMNOPQRSTUVWXYZ  " \
			--text "  abcdefghijklmnopqrstuvwxyz  " \
			--text "  0123456789.:,;(*!?') ff fl fi ffi ffl  " \
			--text "  The quick brown fox jumps over the lazy dog.  " \
			"${FILE_PATH}";
		then
			convert -- "$preview_png" "$IMAGE_CACHE_PATH" \
				&& rm "$preview_png" \
				&& exit 6
		else
			exit 1
		fi
		;;
	esac

	openscad_image() {
		# shellcheck disable=SC2155
		local TMPPNG="$(mktemp -t XXXXXX.png)"
		openscad --colorscheme="$OPENSCAD_COLORSCHEME" \
			--imgsize="${OPENSCAD_IMGSIZE/x/,}" \
			-o "$TMPPNG" "$1"
		mv "$TMPPNG" "$IMAGE_CACHE_PATH"
	}

	case "$fileExtension" in
	# 3D models
	# OpenSCAD only supports png image output, and ${IMAGE_CACHE_PATH}
	# is hardcoded as jpeg. So we make a tempfile.png and just
	# move/rename it to jpg. This works because image libraries are
	# smart enough to handle it
	csg|scad)
		openscad_image "$FILE_PATH" && exit 6
		;;
	3mf|amf|dxf|off|stl)
		openscad_image <(echo "import(\"${FILE_PATH}\");") && exit 6
		;;
	esac
}


handle_extension() {
	local fileExtension="$1"

	case "$fileExtension" in
	## archives ##
	a|ace|alz|arc|arj|bz|bz2|cab|cpio|deb|gz|jar|lha|lz|lzh|lzma|lzo|\
	rpm|rz|t7z|tar|tbz|tbz2|tgz|tlz|txz|tZ|tzo|war|xpi|xz|Z|zip)
		atool --list -- "$FILE_PATH" && exit 5
		bsdtar --list --file "$FILE_PATH" && exit 5
		exit 1
		;;
	rar)
		# Avoid password prompt by providing empty password
		unrar lt -p- -- "$FILE_PATH" && exit 5
		exit 1
		;;
	7z)
		# Avoid password prompt by providing empty password
		7z l -p -- "$FILE_PATH" && exit 5
		exit 1
		;;

	## documents ##
	pdf)
		# to text
		pdftotext -l 10 -nopgbrk -q -- "$FILE_PATH" - | \
				fmt -w "$PV_WIDTH" \
			&& exit 5

		# to text
		mutool draw -F txt -i -- "$FILE_PATH" 1-10 | \
				fmt -w "$PV_WIDTH" \
			&& exit 5

		exiftool "$FILE_PATH" && exit 5

		exit 1
		;;

	odt|ods|odp|sxw)
		# to text
		odt2txt "$FILE_PATH" && exit 5

		# to markdown
		pandoc -s -t markdown -- "$FILE_PATH" && exit 5

		exit 1
		;;

	xlsx)
		# Preview as csv conversion
		# Uses: https://github.com/dilshod/xlsx2csv
		xlsx2csv -- "$FILE_PATH" && exit 5

		exit 1
		;;

	## text ##
	torrent)
		transmission-show -- "$FILE_PATH" && exit 5

		exit 1
		;;

	# HTML
	htm|html|xhtml)
		# Preview as text conversion
		w3m -dump "$FILE_PATH" && exit 5
		lynx -dump -- "$FILE_PATH" && exit 5
		elinks -dump "$FILE_PATH" && exit 5
		pandoc -s -t markdown -- "$FILE_PATH" && exit 5
		;;

	# JSON
	json)
		jq --color-output . "$FILE_PATH" && exit 5
		python -m json.tool -- "$FILE_PATH" && exit 5
		;;

	# Direct Stream Digital/Transfer (DSDIFF) and wavpack aren't detected
	# by file(1).
	dff|dsf|wv|wvc)
		mediainfo "$FILE_PATH" && exit 5
		exiftool "$FILE_PATH" && exit 5
		;;

	# mimeType: application/octet-stream
	p12)
		openssl pkcs12 -info -nokeys -passin pass: -in "$FILE_PATH" && exit 5
	esac
}

handle_mime() {
	local mimetype="$1"

	case "$mimetype" in
	# RTF and DOC
	text/rtf|*msword)
		# Preview as text conversion
		# note: catdoc does not always work for .doc files
		# catdoc: http://www.wagner.pp.ru/~vitus/software/catdoc/
		catdoc -- "$FILE_PATH" && exit 5
		exit 1
		;;

	# DOCX, ePub, FB2 (using markdown)
	# You might want to remove "|epub" and/or "|fb2" below if you have
	# uncommented other methods to preview those formats
	*wordprocessingml.document|*/epub+zip|*/x-fictionbook+xml)
		## Preview as markdown conversion
		pandoc -s -t markdown -- "$FILE_PATH" && exit 5
		exit 1
		;;

	# XLS
	*ms-excel)
		# Preview as csv conversion
		# xls2csv comes with catdoc:
		#   http://www.wagner.pp.ru/~vitus/software/catdoc/
		xls2csv -- "$FILE_PATH" && exit 5
		exit 1
		;;

	# Text
	text/* | */xml)
		# Syntax highlight
		if [[ "$(stat --printf='%s' -- "${FILE_PATH}")" -gt "${HIGHLIGHT_SIZE_MAX}" ]]; then
			exit 2
		fi

		if [[ "$(tput colors)" -ge 256 ]]; then
			local pygmentize_format='terminal256'
			local highlight_format='xterm256'
		else
			local pygmentize_format='terminal'
			local highlight_format='ansi'
		fi

		HIGHLIGHT_OPTIONS="$HIGHLIGHT_OPTIONS" highlight \
				--out-format="${highlight_format}" \
				--force -- "${FILE_PATH}" \
			&& exit 5

		COLORTERM=8bit bat --color=always --style='plain' \
				-- "$FILE_PATH" \
			&& exit 5

		pygmentize -f "${pygmentize_format}" -O "style=$PYGMENTIZE_STYLE"\
				-- "$FILE_PATH" \
			&& exit 5

		exit 2
		;;

	# DjVu
	image/vnd.djvu)
		# Preview as text conversion (requires djvulibre)
		djvutxt "$FILE_PATH" | fmt -w "$PV_WIDTH" && exit 5
		exiftool "$FILE_PATH" && exit 5
		exit 1
		;;

	# Image
	image/*)
		# to text
		# img2txt --gamma=0.6 --width="${PV_WIDTH}" -- "${FILE_PATH}" && exit 4
		exiftool "$FILE_PATH" && exit 5
		exit 1
		;;

	# Video and audio
	video/* | audio/*)
		mediainfo "$FILE_PATH" && exit 5
		exiftool "$FILE_PATH" && exit 5
		exit 1
		;;
	esac
}

handle_fallback() {
	local fileExtension="$1"

	echo '----- File Type Classification -----'
	file --dereference --brief -- "$FILE_PATH" && exit 5

	exit 1
}

FILE_EXTENSION="${FILE_PATH##*.}"
FILE_EXTENSION_LOWER="${FILE_EXTENSION,,}"

MIMETYPE="$(file --dereference --brief --mime-type -- "$FILE_PATH")"
if [ "${PV_IMAGE_ENABLED}" = 'True' ]; then
	handle_image "$MIMETYPE" "$FILE_EXTENSION_LOWER"
fi

handle_mime "$MIMETYPE"
handle_extension "$FILE_EXTENSION_LOWER"
handle_fallback "$FILE_EXTENSION_LOWER"

exit 1
