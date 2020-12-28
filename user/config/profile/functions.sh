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

mkcd() {
	mkdir -p -- "$@"
	cd -- "$@" || return
}

mkt() {
	dir="$(mktemp -d)"

	[ -n "$1" ] && {
		case "$1" in
		https://github.com/*|git@github.com:*)
			cd "$dir" || return
			git clone "$1"
			cd ./* || return
			;;
		https://*.tar*|https://*.zip)
			cd "$dir" || return
			cd ./* || return
			curl -LO "$1"
			;;
		*)
			mv "$1" "$dir"
			cd "$dir" || return
			;;
		esac

		return
	}

	cd "$dir" || return
}

o() {
	if [ $# -eq 0 ]; then
		xdg-open .
	else
		xdg-open "$@"
	fi
}

r() {
	# shellcheck disable=SC2015
	type trash-rm >/dev/null 2>&1 && {
		trash-rm "$@"; true
		true
	} || {
		echo "Info: trash-rm not found" >&2
		rm --preserve-root=all "$@"
	}
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
