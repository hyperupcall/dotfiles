# shellcheck shell=sh

_p_log_error() {
	printf "\033[0;31m%s\033[0m\n" "ERROR: $*" >&2
}

_p_die() {
	_p_log_error "$*"
	return 1
}

cdls() {
	cd "$1" || return
	command -v >/dev/null 2>&1 && {
				exa -al
				return
	}
	ls -al
}

archive-list() {
	case "$1" in
	*.zip)
				unzip -l "$1"
				;;
	*)
				echo "Error: No match found" >&2
				;;
	esac
}

archive-uncompress() {
	for arg; do
	case "$arg" in
	*.zip)
		folder="$(echo "$1" | rev | cut -d'.' -f2- | rev)"
		unzip -d "$folder" "$1"
		[ -f "$folder" ] && return
		cd "$folder" || return
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

docker_nuke() {
	docker ps -q | xargs docker stop
	docker ps -aq | xargs docker rm
	docker images | grep none | col 3 | xargs docker rmi -f
}

dg() {
	dig +nocmd "$1" any +multiline +noall +answer
}

fcliflix() (
		  mkcd "$HOME/repos/fox-night/local/dl"
		  if [ "$(ls . | wc -l)" -ne 0 ]; then
					 echo "fcliflix: $HOME/repos/fox-night/local/dl not empty. Exiting"
					 exit 1
		  fi

		  cliflix --torrentProvider 1337x --moviePlayer None --subtitleLanguage English --saveMedia --downloadDir "$HOME/repos/fox-night/local/dl" \
					 || { echo "fcliflix: Exited early. Exiting"; exit 1; }
		  mv **/*.{mp4,mkv} ../movie2.mp4
		  ffmpeg -i **/*.srt ../captions2.vtt

		  # todo: info.toml, no moviePlayera
		  # ensure movie playable in browser (no dolby 5.1ss / mpeg4 encoding)
)

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

# TODO: do
_mkt_log() {
	echo "$dir"
	echo "$(date '+%b %d - %I:%M:%S') | $dir | $1" >> "$HOME/.history/mkt_history"
}
_mkt_ls() {
	type exa >/dev/null 2>&1 && exa -al && return
	ls -al
}
mkt() {
	dir="$(mktemp -d)"

	# nothing passed
	[ -z "$1" ] && {
		cd "$dir" || return
		unset -v dir
		return
	}

	case "$1" in
	# TODO: code duplication of 'remote files'
	*.zip)
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
		*.tar*)
				mv "$1" "$dir"
				cd "$dir" || return

				echo "mkt: Unarchiving $(basename "$1")"
				tar xaf ./*
				cd ./*/ || return


				type exa >/dev/null 2>&1 && exa -al && return
				ls -al
				;;
		  *.zip)
				mv "$1" "$dir"
				cd "$dir" || return

				echo "mkt: Unarchiving $(basename "$1")"
				unzip ./*
				cd ./*/ || return

				type exa >/dev/null 2>&1 && exa -al && return
				ls -al
				;;
			*)
				cp "$1" "$dir"
				cd "$dir" || return

				type exa >/dev/null 2>&1 && exa -al && return
				ls -al
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

np() {
	mkdir -p "$HOME/repos/$1"
	code "$1"
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

quickedit() (
	cd "$1" || _p_die "Could not cd to '$1'"
	v .
)

serv() {
	[ -d "${1:-.}" ] || { echo "serv: Error: dir '$1' doesn't exist"; return 1; }
	python3 -m http.server --directory "${1:-.}" "${2:-4000}"
}

t() {
	for file; do
		mkdir -p "$(dirname "$file")"
		touch "$file"
	done
}

vtraceroute() {
	xdg-open "https://stefansundin.github.io/traceroute-mapper/?trace=$('traceroute' -q1 "$*" | sed ':a;N;$!ba;s/\n/%0A/g')"
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
      mkdir -p "$(dirname "$1")"
		vim "$1"
	fi
}
