#!/usr/bin/env bash

# dir_colors
test -r "$XDG_CONFIG_HOME/dircolors/dir_colors" \
	&& eval "$(dircolors --sh "$XDG_CONFIG_HOME/dircolors/dir_colors")"

# x11
#xhost +local:root >/dev/null 2>&1

#eval "$(gnome-keyring-daemon -s)"

# Create a new directory and enter it
mkd() {
	mkdir -p "$@"
	cd "$@" || exit
}

# Make a temporary directory and enter it
tmpd() {
	local dir
	if [ $# -eq 0 ]; then
		dir=$(mktemp -d)
	else
		dir=$(mktemp -d -t "${1}.XXXXXXXXXX")
	fi
	cd "$dir" || exit
}

# Determine size of a file or total size of a directory
fs() {
	if du -b /dev/null > /dev/null 2>&1; then
		local arg=-sbh
	else
		local arg=-sh
	fi
	# shellcheck disable=SC2199
	if [[ -n "$@" ]]; then
		du $arg -- "$@"
	else
		du $arg -- .[^.]* *
	fi
}

# Create a data URL from a file
dataurl() {
	local mimeType
	mimeType=$(file -b --mime-type "$1")
	if [[ $mimeType == text/* ]]; then
		mimeType="${mimeType};charset=utf-8"
	fi
	echo "data:${mimeType};base64,$(openssl base64 -in "$1" | tr -d '\n')"
}

# Create a git.io short URL
gitio() {
	if [ -z "${1}" ] || [ -z "${2}" ]; then
		echo "Usage: \`gitio slug url\`"
		return 1
	fi
	curl -i https://git.io/ -F "url=${2}" -F "code=${1}"
}

# Start an HTTP server from a directory, optionally specifying the port
server() {
	local port="${1:-8000}"
	sleep 1 && open "http://localhost:${port}/" &
	# Set the default Content-Type to `text/plain` instead of `application/octet-stream`
	# And serve everything as UTF-8 (although not technically correct, this doesn’t break anything for binary files)
	python -c $'import SimpleHTTPServer;\nmap = SimpleHTTPServer.SimpleHTTPRequestHandler.extensions_map;\nmap[""] = "text/plain";\nfor key, value in map.items():\n\tmap[key] = value + ";charset=UTF-8";\nSimpleHTTPServer.test();' "$port"
}

# Syntax-highlight JSON strings or files
# Usage: `json '{"foo":42}'` or `echo '{"foo":42}' | json`
json() {
	if [ -t 0 ]; then # argument
		python -mjson.tool <<< "$*" | pygmentize -l javascript
	else # pipe
		python -mjson.tool | pygmentize -l javascript
	fi
}

# Run `dig` and display the most useful info
digga() {
	dig +nocmd "$1" any +multiline +noall +answer
}

# Query Wikipedia via console over DNS
mwiki() {
	dig +short txt "$*".wp.dg.cx
}

# UTF-8-encode a string of Unicode symbols
escape() {
	local args
	mapfile -t args < <(printf "%s" "$*" | xxd -p -c1 -u)
	printf "\\\\x%s" "${args[@]}"
	# print a newline unless we’re piping the output to another program
	if [ -t 1 ]; then
		echo ""; # newline
	fi
}

# Decode \x{ABCD}-style Unicode escape sequences
unidecode() {
	perl -e "binmode(STDOUT, ':utf8'); print \"$*\""
	# print a newline unless we’re piping the output to another program
	if [ -t 1 ]; then
		echo ""; # newline
	fi
}

# Get a character’s Unicode code point
codepoint() {
	perl -e "use utf8; print sprintf('U+%04X', ord(\"$*\"))"
	# print a newline unless we’re piping the output to another program
	if [ -t 1 ]; then
		echo ""; # newline
	fi
}

# Show all the names (CNs and SANs) listed in the SSL certificate
# for a given domain
getcertnames() {
	if [ -z "${1}" ]; then
		echo "ERROR: No domain specified."
		return 1
	fi

	local domain="${1}"
	echo "Testing ${domain}…"
	echo ""; # newline

	local tmp
	tmp=$(echo -e "GET / HTTP/1.0\\nEOT" \
		| openssl s_client -connect "${domain}:443" 2>&1)

	if [[ "${tmp}" = *"-----BEGIN CERTIFICATE-----"* ]]; then
		local certText
		certText=$(echo "${tmp}" \
			| openssl x509 -text -certopt "no_header, no_serial, no_version, \
			no_signame, no_validity, no_issuer, no_pubkey, no_sigdump, no_aux")
		echo "Common Name:"
		echo ""; # newline
		echo "${certText}" | grep "Subject:" | sed -e "s/^.*CN=//"
		echo ""; # newline
		echo "Subject Alternative Name(s):"
		echo ""; # newline
		echo "${certText}" | grep -A 1 "Subject Alternative Name:" \
			| sed -e "2s/DNS://g" -e "s/ //g" | tr "," "\\n" | tail -n +2
		return 0
	else
		echo "ERROR: Certificate not found."
		return 1
	fi
}

# `v` with no arguments opens the current directory in Vim, otherwise opens the
# given location
v() {
	if [ $# -eq 0 ]; then
		vim .
	else
		vim "$@"
	fi
}

# `o` with no arguments opens the current directory, otherwise opens the given
# location
o() {
	if [ $# -eq 0 ]; then
		xdg-open .	> /dev/null 2>&1
	else
		xdg-open "$@" > /dev/null 2>&1
	fi
}

# `tre` is a shorthand for `tree` with hidden files and color enabled, ignoring
# the `.git` directory, listing directories first. The output gets piped into
# `less` with options to preserve color and line numbers, unless the output is
# small enough for one screen.
tre() {
	tree -aC -I '.git' --dirsfirst "$@" | less -FRNX
}

openimage() {
	local types='*.jpg *.JPG *.png *.PNG *.gif *.GIF *.jpeg *.JPEG'

	cd "$(dirname "$1")" || exit
	local file
	file=$(basename "$1")

	feh -q "$types" --auto-zoom \
		--sort filename --borderless \
		--scale-down --draw-filename \
		--image-bg black \
		--start-at "$file"
}

# get dbus session
dbs() {
	local t=$1
	if [[  -z "$t" ]]; then
		local t="session"
	fi

	dbus-send --$t --dest=org.freedesktop.DBus \
		--type=method_call	--print-reply \
		/org/freedesktop/DBus org.freedesktop.DBus.ListNames
}

# check if uri is up
isup() {
	local uri=$1

	if curl -s --head  --request GET "$uri" | grep "200 OK" > /dev/null ; then
		notify-send --urgency=critical "$uri is down"
	else
		notify-send --urgency=low "$uri is up"
	fi
}

xname(){
	local window_id=$1

	if [[ -z $window_id ]]; then
		echo "Please specifiy a window id, you find this with 'xwininfo'"

		return 1
	fi

	local match_string='".*"'
	local match_qstring='"[^"\\]*(\\.[^"\\]*)*"' # NOTE: Adds 1 backreference

	# get the name
	xprop -id "$window_id" | \
		sed -nr \
		-e "s/^WM_CLASS\\(STRING\\) = ($match_qstring), ($match_qstring)$/instance=\\1\\nclass=\\3/p" \
		-e "s/^WM_WINDOW_ROLE\\(STRING\\) = ($match_qstring)$/window_role=\\1/p" \
		-e "/^WM_NAME\\(STRING\\) = ($match_string)$/{s//title=\\1/; h}" \
		-e "/^_NET_WM_NAME\\(UTF8_STRING\\) = ($match_qstring)$/{s//title=\\1/; h}" \
		-e "\${g; p}"
}
