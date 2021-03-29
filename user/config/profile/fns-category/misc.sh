# shellcheck shell=sh

cls() {
	clear
	reset
	tput reset
	tput rs1
	stty sane
	printf "\033c"
	printf '\033\143'
	sttyy
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

do_backup() {
	restic --repo /storage/vault/rodinia/backups/ backup /storage/edwin/ --iexclude "node_modules" --iexclude "__pycache__" --iexclude "rootfs"
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

isup() {
	'curl' -sS --head --X GET "$1" | grep "200 OK" >/dev/null
}

lb() {
	command lsblk -o NAME,FSTYPE,LABEL,FSSIZE,FSUSED,FSAVAIL,FSUSE%,MOUNTPOINT
}

np() {
	mkdir -p "$HOME/repos/$1"
	code "$HOME/repos/$1"
}

qe() {
	cd "${XDG_CONFIG_HOME}" || { _profile_util_die "qe: Could not cd"; return; }
	_qe_file="$(
		find -L . -ignore_readdir_race -readable -writable -print \
		| grep -Ev '(BraveSoftware|Code|tetrio-desktop|obsidian|Ryujinx|unity3d|Beaker Browser|hmcl|gdlauncher|Helios Launcher|TabNine|zettlr|lunarclient|libreoffice|VirtualBox|configstore|pulse|obs-studio)' \
		| fzf
	)"
	cd - || { _p_die "Could not cd to '..'"; return; }

	[ -z "$_qe_file" ] && { _profile_util_die "qe: Chosen file empty"; return; }

	_qe_file="$XDG_CONFIG_HOME/$(printf "%s" "$_qe_file" | cut -c3-)"
	v "$_qe_file"
	history -s "v \"$_qe_file\""
}

quickedit() (
	cd "$1" || { _p_die "Could not cd to '$1'"; return; }
	v .
)

serv() {
	[ -d "${1:-.}" ] || { _profile_util_die "serv: dir '$1' doesn't exist"; return; }
	command -v http-server && {
		http-server "${1:-.}" -c-1 -a 127.0.0.1 -p "${2:-4000}"
		return
	}
	python3 -m http.server --directory "${1:-.}" "${2:-4000}"
}

vtraceroute() {
	xdg-open "https://stefansundin.github.io/traceroute-mapper/?trace=$('traceroute' -q1 "$*" | sed ':a;N;$!ba;s/\n/%0A/g')"
}
