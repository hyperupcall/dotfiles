#!/bin/sh -eu

# SECRET_GOOGLE_FONTS_API_KEY="..."
. .env.env

# ------------------- helper functions ------------------- #
hasColor() {
	test -t 1 && command -v tput >/dev/null 2>&1 \
		&& test -n "$(tput colors)" && test "$(tput colors)" -ge 8
}

printInfo() {
	if hasColor; then
		printf "\033[0;94m"
		# shellcheck disable=SC2059
		printf "$@"
		printf "\033[0m"
	else
		# shellcheck disable=SC2059
		printf "$@"
	fi
}

printError() {
	if hasColor; then
		printf "\033[0;91m"
		# shellcheck disable=SC2059
		printf "$@" >&2
		printf "\033[0m"
	else
		# shellcheck disable=SC2059
		printf "$@"
	fi
}

# ------------------------ checks ------------------------ #
for dependency in xdotool sxiv convert fzf jq curl; do
	command -v "$dependency" >/dev/null 2>&1 || {
		printError "error: Must have $dependency installed. Exiting.\n"
		exit 1
	}
done

test ! -z "$SECRET_GOOGLE_FONTS_API_KEY" \
	|| (
		printError "The secret key does not have a value. Exiting.\n"
		exit 1
	)

# ------------------------- main ------------------------- #
res="$(curl --silent -o- "https://www.googleapis.com/webfonts/v1/webfonts?key=$SECRET_GOOGLE_FONTS_API_KEY")"

test "$(echo "$res" | jq 'has("error")')" = "true" \
	&& (
		printError "Received error from Google Fonts API. Response:\n$res"
		exit 1
	)

# base64 beccause each object can have newlines
# for fontObjEncoded in $(echo "$res" | jq -r ".items[] | @base64"); do
# 	fontObj="$(echo "$fontObjEncoded" | base64 --decode)"

# 	echo "$fontObj" | jq
# 	# echo "$fontObj" | jq '.family'
# done

fontObj='{
  "kind": "webfonts#webfont",
  "family": "Alef",
  "category": "sans-serif",
  "variants": [
    "regular",
    "700"
  ],
  "subsets": [
    "hebrew",
    "latin"
  ],
  "version": "v11",
  "lastModified": "2019-07-16",
  "files": {
    "regular": "http://fonts.gstatic.com/s/alef/v11/FeVfS0NQpLYgrjJbC5FxxbU.ttf",
    "700": "http://fonts.gstatic.com/s/alef/v11/FeVQS0NQpLYglo50L5la2bxii28.ttf"
  }
}'

SEARCH_PROMPT="❯ "
SIZE=532x365
POSITION="+0+0"
FONT_SIZE=38
BG_COLOR="#ffffff"
FG_COLOR="#000000"
PREVIEW_TEXT="ABCDEFGHIJKLM\nNOPQRSTUVWXYZ\nabcdefghijklm\nnopqrstuvwxyz\n1234567890\n!@$\%(){}[]"

sxiv -N "fontpreview" -b -g "$SIZE$POSITION" "$FONT_PREVIEW" &
pre_exit() {
	# Get the proccess ID of this script and kill it.
	# We are dumping the output of kill to /dev/null
	# because if the user quits sxiv before they
	# exit this script, an error will be shown
	# from kill and we dont want that
	kill -9 "$(cat "$PIDFILE" 2>/dev/null)" &>/dev/null

	# Delete tempfiles, so we don't leave useless files behind.
	rm -rf "$FONTPREVIEW_DIR"
}

generate_preview() {
	# Credits: https://bit.ly/2UvLVhM
	convert -size $SIZE xc:"$BG_COLOR" \
		-gravity center \
		-pointsize $FONT_SIZE \
		-font "$1" \
		-fill "$FG_COLOR" \
		-annotate +0+0 "$PREVIEW_TEXT" \
		-flatten "$2"
}

# Disable CTRL-Z because if we allowed this key press,
# then the script would exit but, sxiv would still be
# running
trap "" TSTP

trap pre_exit EXIT

# tmp dir
FONTPREVIEW_DIR="$(mktemp -d "${TMPDIR:-/tmp}/fontpreview_dir.XXXXXXXX")"
PIDFILE="$FONTPREVIEW_DIR/fontpreview.pid"
touch "$PIDFILE"
FONT_PREVIEW="$FONTPREVIEW_DIR/fontpreview.png"
touch "$FONT_PREVIEW"
TERMWIN_IDFILE="$FONTPREVIEW_DIR/fontpreview.termpid"
touch "$TERMWIN_IDFILE"

# Point a font file to fontpreview and it will preview it.
# Example:
#   $ fontpreview /path/to/fontFile.ttf
if [ -f "$1" ]; then
	generate_preview "$1" "$FONT_PREVIEW"

	# Display the font preview using sxiv
	sxiv -g "$SIZE$POSITION" -N "fontpreview" -b "$FONT_PREVIEW" &

	# For some strange reason, sxiv just doesnt have time to read the file
	sleep 0.1
	exit
fi
