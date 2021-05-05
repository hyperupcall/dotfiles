# shellcheck shell=sh

# clone(user, root)
cls() {
	# TODO
	clear
	reset
	tput reset
	tput rs1
	# uses our function
	stty sane
	printf "\033c"
	printf '\033\143'
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

	unset -v mimeType str
}

do_backup() {
	restic --repo /storage/vault/rodinia/backups/ backup /storage/edwin/ --iexclude "node_modules" --iexclude "__pycache__" --iexclude "rootfs" --iexclude "Dls/cliflix" --iexclude "Dls/youtube-dl"
	restic --repo /storage/vault/rodinia/backups-data/ backup /storage/data/ --iexclude "node_modules" --iexclude "__pycache__" --iexclude "rootfs" --iexclude "Dls/cliflix" --iexclude "Dls/youtube-dl"
}

docker_nuke() {
	docker ps -q | xargs docker stop
	docker ps -aq | xargs docker rm
	docker images | grep none | col 3 | xargs docker rmi -f
}

# clone(user, root)
dg() {
	dig +nocmd "$1" any +multiline +noall +answer
}

eboot() {
	_eboot_dir="$HOME/repos/dots-bootstrap/lib/install_modules"
	_eboot_file="$(
		find "$_eboot_dir" -ignore_readdir_race -mindepth 1 -maxdepth 1 -printf "%f\0" | fzf --read0
	)"

	[ -z "$_eboot_file" ] && {
		_profile_util_die "eboot: No file chosen"
		return
	}

	v "$_eboot_dir/$_eboot_file"

	unset -v _eboot_dir
}

edit() {
	# TODO
	_edit_grep_result="$(grep -nR "^$1() {$" "$XDG_CONFIG_HOME/profile" | head -1)"
	[ -z "$_edit_grep_result" ] && {
		_profile_util_die "edit: Function '$1' not found"
		return
	}

	_edit_file="$(echo "$_edit_grep_result" | awk -F ':' '{ print $1 }')"
	_edit_line="$(echo "$_edit_grep_result" | awk -F ':' '{ print $2 }')"
	v "+$_edit_line" "$_edit_file"
	unset -v _edit_grep_result _edit_file _edit_line
}

# clone(user, root)
faketty() {
	unbuffer -p "@"
}

# gclonedir() {
# 	urlEncoded="$(jq -rn --arg x "$1" '$x | @uri')"
# 	wget "https://download-directory.github.io/?url=$urlEncoded"
# }

# clone(user, root)
isup() {
	command curl -sS --head --X GET "$1" | grep -q '200 OK'
}

# clone(user, root)
kkexec() {
	sudo kexec -l /efi/EFI/arch/vmlinuz-linux-lts --initrd /efi/EFI/arch/initramfs-linux-lts.img --reuse-cmdline
	sudo systemctl kexec
	# sudo kexec -e
}

# clone(user, root)
nh() {
	nohup "$@" > /dev/null 2>&1 &
}

np() {
	if [ "$(echo "$1" | awk '{ print substr($1, 0, 1) }')" = "/" ]; then
		mkdir -p "$1"
		code "$1"
	else
		mkdir -p "$HOME/repos/$1"
		code "$HOME/repos/$1"
	fi
}

qe() {
	filterList="BraveSoftware Code tetrio-desktop obsidian discord sublime-text Ryujinx unity3d hmcl hdlauncher TabNine zettlr Zettlr Google lunarclient libreoffice VirtualBox configstore pulse obs-studio eDEX-UI 1Password kde.org sublime-text-3 gdlauncher gdlauncher_next launcher-main gitify QtProject GIMP"

	_qe_file="$(
		cd "$XDG_CONFIG_HOME" || { _profile_util_log_error "qe: Could not cd"; exit 1; }
		filterArgs=
		for file in $filterList; do
			filterArgs="$filterArgs -o -name $file"
		done

		# shellcheck disable=SC2086
		find -L . -ignore_readdir_race \( \
			-name 'Beaker Browser' \
			$filterArgs \
			-o -name 'Helios Launcher' -o -path ./kak/plugins \
			-o -path ./kak/autoload \
		\) -prune -o -print | fzf
	)"

	[ -z "$_qe_file" ] && { _profile_util_die "qe: Chosen file empty"; return; }

	_qe_file="$XDG_CONFIG_HOME/$(printf "%s" "$_qe_file" | cut -c3-)"
	v "$_qe_file"
	history -s "v \"$_qe_file\""
}

quickedit() (
	cd "$1" || { _p_die "Could not cd to '$1'"; return; }
	v .
)

# https://unix.stackexchange.com/a/123770
# clone(user, root)
see_old() {
	sudo lsof +c 0 | grep 'DEL.*lib' | awk '1 { print $1 ": " $NF }' | sort -u
}

# clone(user)
serv() {
	[ -d "${1:-.}" ] || { _profile_util_die "serv: dir '$1' doesn't exist"; return; }
	command -v file_server >/dev/null 2>&1 && {
		# deno file_server
		file_server "${1:-.}" --host 127.0.0.1 -p "${2:-4000}"
		return
	}
	command -v http-server >/dev/null 2>&1 && {
		# node http server
		http-server "${1:-.}" -c-1 -a 127.0.0.1 -p "${2:-4000}"
		return
	}
	python3 -m http.server --directory "${1:-.}" "${2:-4000}"
}

vtraceroute() {
	xdg-open "https://stefansundin.github.io/traceroute-mapper/?trace=$('traceroute' -q1 "$*" | sed ':a;N;$!ba;s/\n/%0A/g')"
}
