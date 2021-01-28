# shellcheck shell=sh

cdls() {
	cd "$1" || return
	command -v >/dev/null 2>&1 && {
				exa -al
				return
	}
	ls -al
}

cl() {
	case "$1" in
	*.zip)
				unzip -l "$1"
				;;
	*)
				echo "Error: No match found" >&2
				;;
	esac
}

cx() {
	for arg; do
	case "$arg" in
	*.zip)
		folder="$(echo "$1" | rev | cut -d'.' -f2- | rev)"
		unzip -d "$folder" "$1"
		[ -f "$folder" ] && return
		cd "$folder" || exit
		[ "$(find . -maxdepth 1 | cut -c 3- | wc -l)" = 1 ] && {
			subfolder="$(ls)"
			mv "./$subfolder"/* "./$subfolder"/.* .
			rmdir "$subfolder"
			cd ..
		}
		;;
	*)
		echo "Error: No match found" >&2
		;;
	esac
	done
}

chr() {
	: "${1:?"Error: No mountpoint specified"}"
	[ -d "$1" ] || { echo "Error: Folder doesn't exist"; exit 1; }

	type arch-chroot >/dev/null 2>&1 && {
		arch-chroot "$1"
		return
	}

	sudo mount -o bind -t proc /proc/ "$1/proc"
	sudo mount -o bind -t sysfs /sys "$1/sys"
	sudo mount -o bind -t tmpfs /run "$1/run"
	sudo mount -o bind -t devtmpfs /dev "$1/dev"

	[ "$TERM" = xterm-kitty ] && {
		TERM=xterm-256color
		sudo chroot "$1"
		TERM=xterm-kitty
		return
	}

	sudo chroot "$1"
}

del() {
	if command -v gio > /dev/null; then
		for f; do
			gio trash -f "$f"
		done
	elif command -v gvfs-trash > /dev/null; then
		for f; do
			gvfs-trash "$f"
		done
	elif [ -d "${XDG_DATA_HOME:-$HOME/.local/share}/Trash/files" ]; then
		for f; do
			mv "$f" "${XDG_DATA_HOME:-$HOME/.local/share}/Trash/files"
		done
	else
		for f; do
			'rm' "$f"
		done
	fi
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

lb() {
		  lsblk -o NAME,FSTYPE,LABEL,FSUSED,FSAVAIL,FSSIZE,FSUSE%,MOUNTPOINT
}

mkcd() {
	mkdir -p -- "$@"
	cd -- "$@" || return
}

mkt() {
	dir="$(mktemp -d)"
	echo "$dir"

	# nothing passed
	[ -z "$1" ] && {
		cd "$dir" || return
		unset -v dir
		return
	}

	case "$1" in
	# git repository
	*.git|https://github.com/*|git@github.com:*|https://gitlab.com/*|git@gitlab.com:*)
		cd "$dir" || return
		git clone "$1"
		cd ./* || return

		type exa >/dev/null 2>&1 && exa -al && return
		ls -al
		;;
	# remote files
	https://*)
		cd "$dir" || return
		curl -LO "$1"

		case "$(echo ./*)" in
			*.tar) tar xaf ./* ;;
			*.zip) unzip ./* ;;
			*) "mkt: Unsure what to do file filetype"
		esac

		# if one directory, cd into it
		[ "$(find . -mindepth 1 -maxdepth 1 -type d | wc -l)" -eq 1 ] && {
			cd ./* || return
		}

		type exa >/dev/null 2>&1 && exa -al && return
		ls -al
		;;
	# github repository shorthand
	*/*)
		! curl -sSLIo /dev/null "https://github.com/$1" && return

		cd "$dir" || return
		git clone "https://github.com/$1"
		cd ./* || return

		type exa >/dev/null 2>&1 && exa -al && return
		ls -al
		;;
	*)
		if [ -d "$1" ] || [ -f "$1" ]; then
			case "$1" in
			*.tar*|*.zip)
				mv "$1" "$dir"
				cd "$dir" || return
				echo "mkt: Unarchiving $(basename "$1")"
				tar xaf ./*
				;;
			*)
				echo "mkt: Unsure what to do file filetype"
			;;
			esac
		else
			mv "$dir" "$dir-$1"
			cd "$dir-$1" || return
		fi
		;;
	esac

	unset -v dir
}

o() {
	if [ $# -eq 0 ]; then
		xdg-open .
	else
		xdg-open "$@"
	fi
}

pdfgrep() {
	find . -name '*.pdf' -exec sh -c '/usr/bin/pdftotext "{}" - | grep --with-filename --label="{}" --color '"$1" \;
}

put() {
	case "$1" in
	*.deb|*.rpm)
		mv "$1" "$HOME/Docs/pkg/system-package/$(basename "$1")"
		cd ~/Docs/pkg/systemd-package || return
		;;
	*)
		;;
	esac
}

qe() {
	file="$(nim r --hints:off "$XDG_CONFIG_HOME/dotty/dotty.nim" | fzf)"
	vim "$file"
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
	case "$*" in
	--help|--version)
		command unlink "$@"
		;;
	esac

	for file; do
		command unlink "$file"
	done
}

v() {
	if [ $# -eq 0 ]; then
		vim .
	else
		vim "$@"
	fi
}
