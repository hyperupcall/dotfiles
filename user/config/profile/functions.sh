# shellcheck shell=sh

codepoint() {
	perl -e "use utf8; print sprintf('U+%04X', ord(\"$*\"))"

	# print newline if we're not piping to another program
	[ -t 1 ] && echo
}

chr() {
	: "${1:?"Error: No mountpoint specified"}"
	[ -d "$1" ] || { echo "Error: Folder doesn't exist"; exit 1; }

	sudo mount -o bind -t proc /proc/ "$1/proc"
	sudo mount -o bind -t sysfs /sys "$1/sys"
	sudo mount -o bind -t tmpfs /run "$1/run"
	sudo mount -o bind -t devtmpfs /dev "$1/dev"

	[ "$TERM" = xterm-kitty ] && {
		TERM=xterm
		sudo chroot "$1"
		TERM=xterm-kitty
		return
	}

	sudo chroot "$1"
}

dataurl() {
	mimeType=$(file -b --mime-type "$1")
	case "$mimeType" in
		text/*)
			mimeType="${mimeType};charset=utf-8"
		;;
	esac

	str="$(openssl base64 -in "$1" | tr -d '\n')"
	printf "data:${mimeType};base64,%s\n" "$str"

	unset -v mimeType
	unset -v str
}

dbs() {
	dbus-send --"${1:-session}" \
		--dest=org.freedesktop.DBus \
		--type=method_call \
		--print-reply \
		/org/freedesktop/DBus org.freedesktop.DBus.ListNames
}

doBackup() {
	restic --repo /storage/vault/rodinia/backups/ backup /storage/edwin/ --iexclude "node_modules" --iexclude "__pycache__" --iexclude "rootfs"
}

doBackup2() {
	restic --repo /storage/vault/rodinia/backups-data/ backup /storage/data/ --iexclude "node_modules" --iexclude "__pycache__" --iexclude "rootfs"
}

dg() {
	dig +nocmd "$1" any +multiline +noall +answer
}

isup() {
	curl -sS --head --X GET "$1" | grep "200 OK" >/dev/null
}

k() {
	nb add "$@"
	kb add "$@"
}

lb() {
	lsblk -o NAME,FSTYPE,LABEL,FSUSED,FSAVAIL,FSSIZE,FSUSE%,MOUNTPOINT
}

mkc() {
	mkdir -- "$@" && cd -- "$@"
}

mkd() {
	mkdir -p "$@"
	cd "$@" || exit
}

mkt() {
	dir="$(mktemp -d)"

	[ -n "$1" ] && {
		case "$1" in
		https://github.com/*|git@github.com:*)
			git clone "$1"
			cd *
			;;
		*)
			mv "$1" "$dir"
			cd "$dir"
			;;
		esac

		return
	}

	cd "$dir"
}

o() {
	if [ $# -eq 0 ]; then
		xdg-open .
	else
		xdg-open "$@"
	fi
}

oimg() {
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

openimage() {
	cd "$(dirname "$1")" || {
		echo "Error: Could not cd into $1"
		return 1
	}

	feh -q \
		*.{jpg,JPG,png,PNG,gif,GIF,jpeg,JPEG}
		--auto-zoom \
		--sort filename --borderless \
		--scale-down --draw-filename \
		--image-bg black \
		--start-at "$file"
}

serv() {
	[ -d "${1:-.}" ] || { echo "Error: dir '$1' doesn't exist"; return 1; }
	python3 -m http.server --directory "${1:-.}" "${2:-4000}"
}

tre() {
	tree -a \
		-I '.git' -I '.svn' -I '.hg' \
		--ignore-case --matchdirs --filelimit \
		-h -F --dirsfirst -C "$@"
}

tmpd() {
	[ $# -eq 0 ] && {
		# || return for shellcheck
		cd "$(mktemp -d)" || return
		return
	}

	cd "$(mktemp -d -t "${1}.XXXXXXXXXX")" || return
}

unlink() {
	case "$@" in
	--help|--version)
		command unlink "$@"
		echo donee
		;;
	esac

	for file; do
		command unlink "$file"
	done
}

utf8decode() {
	perl -e "binmode(STDOUT, ':utf8'); print \"$*\""

	# print newline if we're not piping to another program
	[ -t 1 ] && echo
}

utf8encode() {
	mapfile -t args < <(printf "%s" "$*" | xxd -p -c1 -u)
	printf "\\\\x%s" "${args[@]}"

	# print newline if we're not piping to another program
	[ -t 1 ] && echo
}

v() {
	if [ $# -eq 0 ]; then
		vim .
	else
		vim "$@"
	fi
}

weather() {
	curl wttr.in
}
