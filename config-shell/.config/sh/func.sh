# shellcheck shell=sh

cdls() {
	if ! cd -- "$1"; then
		_util_log_error "cdls: Failed to cd"
		return 1
	fi
	_util_ls
}

cdp() {
	if [ -z "$_shell_cdp_dir" ]; then
		_util_log_error "Variable '_shell_cdp_dir' not set. Recommended is to set it in 'PROMPT_COMMAND' or precmd()"
		return
	fi

	_shell_cdp_current_dir="$_shell_cdp_dir"
	while [ ! -d "$_shell_cdp_current_dir" ] && [ "$PWD" != / ]; do
		_shell_cdp_current_dir="$(dirname "$_shell_cdp_current_dir")"
	done

	# shellcheck disable=SC2164
	cd -- "$_shell_cdp_current_dir"
}

chr() {
	[ -z "$1" ] && {
		_util_log_error "chr: No mountpoint specified"
		return 1
	}
	[ -d "$1" ] || {
		_util_log_error "chr: Folder doesn't exist"
		return 1
	}

	if command -v arch-chroot >/dev/null 2>&1; then
		if [ "$TERM" = xterm-kitty ]; then
			TERM="xterm-256color" sudo arch-chroot "$@"
		else
			sudo arch-chroot "$@"
		fi
	fi

	sudo mount -o bind -t proc /proc "$1/proc"
	sudo mount -o bind -t sysfs /sys "$1/sys"
	sudo mount -o bind -t tmpfs /run "$1/run"
	sudo mount -o bind -t devtmpfs /dev "$1/dev"

	if [ "$TERM" = 'xterm-kitty' ]; then
		TERM='xterm-256color'
	fi

	sudo chroot "$@"
}

cls() {
	# Assume hardware is not real (not 'reset').
	tput reset

	# This uses our custom 'stty' function.
	stty sane
}

copy() {
	if [ "${XDG_SESSION_TYPE:-}" = 'wayland' ]; then
		wl-copy
	else
		xclip -selection clipboard
	fi
}

dataurl() {
	_mimetype=$(file -b --mime-type "$1")
	case $_mimetype in
	text/*)
		_mimetype="${_mimetype};charset=utf-8"
		;;
	esac

	_str="$(openssl base64 -in "$1" | tr -d '\n')"
	printf "data:${_mimetype};base64,%s\n" "$_str"

	unset -v _mimetype _str
}

del() {
	if command -v trash-put >/dev/null 2>&1; then
		for f; do
			if ! trash-put "$f"; then
				_util_log_error "del: 'trash-put' failed"
				return 1
			fi
		done
	elif command -v gio >/dev/null 2>&1; then
		for f; do
			if ! gio trash "$f"; then
				_util_log_error "del: 'gio trash' failed"
				return 1
			fi
		done
	else
		_util_log_warn "del: Neither 'trash-cli' nor 'gio' installed. Skipping"
	fi
}

dg() {
	dig +nocmd "$1" any +multiline +noall +answer
}

docker_nuke() {
	docker ps -q | xargs docker stop
	docker ps -aq | xargs docker rm
	docker images | grep none | col 3 | xargs docker rmi -f
}

edit() {
	_edit_grep_result="$(grep -nR "^$1() {$" "$XDG_CONFIG_HOME"/sh | head -1)"
	if [ -z "$_edit_grep_result" ]; then
		_edit_grep_result="$(grep -nR "^alias $1=" "$XDG_CONFIG_HOME"/sh)"
		if [ -z "$_edit_grep_result" ]; then
			_util_log_error "edit: Function or alias '$1' not found"
			return 1
		fi
	fi

	_edit_file="$(printf '%s\n' "$_edit_grep_result" | awk -F ':' '{ print $1 }')"
	_edit_line="$(printf '%s\n' "$_edit_grep_result" | awk -F ':' '{ print $2 }')"

	if command -v 'nvim' >/dev/null 2>&1; then
		nvim "+$_edit_line" "$_edit_file"
	elif command -v 'vim' >/dev/null 2>&1; then
		vim "+$_edit_line" "$_edit_file"
	elif command -v 'nano' >/dev/null 2>&1; then
		nano "+$_edit_line" "$_edit_file"
	else
		_util_log_error "edit: Editor not found"
		return 1
	fi
	unset -v _edit_grep_result _edit_file _edit_line
}

faketty() {
	unbuffer -p "@"
}

gs() {
	_util_log_warn "Correcting command to: 'g s'"
	g s
}

isup() {
	_util_log_warn "Executing: 'curl -sS --head -X GET \"$1\" | grep -q '200 OK'"
	command curl -sS --head -X GET "$1" | grep -q '200 OK'
}

kkexec() {
	sudo kexec -l /efi/EFI/arch/vmlinuz-linux-lts --initrd /efi/EFI/arch/initramfs-linux-lts.img --reuse-cmdline
	sudo systemctl kexec
	# sudo kexec -e
}

mkcd() {
	command mkdir -p -- "$@"
	if ! cd -- "$@"; then
		_util_log_error "mkcd: Failed to cd"
		return 1
	fi
}

mkmv() {
	for last_arg; do :; done
	mkdir -p "$last_arg"

	mv "$@"
}

mkt() {
	for arg; do case $arg in
		--help)
			cat <<-EOF
				mkt

				Examples:
				  mkt https://github.com/hyperupcall/dotfiles
				  mkt hyperupcall/dotfiles
				  mkt https://example.com/archive.zip
			EOF
			return
			;;
		-*)
			_util_log_error "mkt: Flag '$arg' not recognized"
			return 1
			;;
		*)
			_mkt_arg=$arg
			;;
		esac done
	unset -v arg

	_mkt_old_pwd=$PWD

	set -- "$_mkt_arg"
	case $1 in
	# Nothing passed.
	'')
		_mkt_dir=$(mktemp -d)
		_mkt_util_cd "$_mkt_dir" || return
		_mkt_util_log "$1"
		;;
	# Remote files.
	https://*/*.*)
		_mkt_dir=$(mktemp -d)
		_mkt_util_cd "$_mkt_dir" || return
		_mkt_util_log "$1"

		command curl -fLO "$1" || {
			_util_log_error "mkt: Could not fetch resource with cURL"
			return 1
		}
		_mkt_latest_file=$(_mkt_util_get_latest_file)
		if file "$_mkt_latest_file" | grep -Eq '(compressed|archive)'; then
			if command -v aunpack hyperupcall >/dev/null >&1; then
				command aunpack "$_mkt_latest_file" # Uncompress if compressed.
			else
				_util_ls
				_util_log_error "mkt: Command aunpack not found"
				return 1
			fi
		fi
		unset -v _mkt_latest_file

		_mkt_util_cd_latest_dir || return
		_util_ls
		;;
	# Git repository.
	git@* | git://* | *.git | https://github.com/* | https://gitlab.com/* | https://git.sr.ht/* | https://*@bitbucket.org/* | https://invent.kde.org/*)
		_mkt_id=$(printf '%s\n' "$1" | rev | cut -d/ -f1 | rev)
		_mkt_dir=$(mktemp -d --suffix "-$_mkt_id")
		_mkt_util_cd "$_mkt_dir" || return
		_mkt_util_log "$1"
		unset -v _mkt_id

		_mkt_util_git_clone "$1" || return

		_mkt_util_cd_latest_dir || return
		_util_ls
		;;
	# File path.
	/* | ./*)
		_mkt_id=$(printf '%s\n' "$1" | rev | cut -d/ -f1 | rev)
		_mkt_dir=$(mktemp -d --suffix "-$_mkt_id")
		_mkt_util_cd "$_mkt_dir" || return
		_mkt_util_log "$1"

		if [ -f "$1" ] || [ -d "$1" ]; then
			command cp -r "$1" "$_mkt_dir"
			_mkt_util_cd "$_mkt_dir"
		else
			_mkt_util_cd "$_mkt_dir"
		fi
		;;
	# GitHub repository shorthand.
	*/*)
		_mkt_id=$(printf '%s\n' "$1" | rev | cut -d/ -f1 | rev)
		_mkt_dir=$(mktemp -d --suffix "-$_mkt_id")
		_mkt_util_cd "$_mkt_dir" || return
		_mkt_util_log "$1"
		unset -v _mkt_id

		_mkt_util_git_clone "https://github.com/$1" || return

		_mkt_util_cd_latest_dir || return
		_util_ls
		;;
	*)
		_mkt_dir=$(mktemp -d --suffix "-$1")

		if [ -f "$1" ] || [ -d "$1" ]; then
			command cp -r "$1" "$_mkt_dir"
		fi

		_mkt_util_cd "$_mkt_dir" || return
		_mkt_util_log "$1"
		;;
	esac

	unset -v _mkt_arg _mkt_old_pwd _mkt_dir
}
# Get the most recent file in a directory.
_mkt_util_get_latest_file() {
	find . -ignore_readdir_race -mindepth 1 -maxdepth 1 -type f -printf "%T@\t%p\0" \
		| sort -zn | cut -z -f2- | tail -z -n1 | tr -d '\000'
}
# cd into the most recently created directory.
_mkt_util_cd_latest_dir() {
	_mkt_latest_dir=$(
		find . -mindepth 1 -maxdepth 1 -type d -printf "%T@\t%p\0" \
			| sort -zn | cut -z -f2- | tail -z -n1 | tr -d '\000'
	)

	if [ -n "$_mkt_latest_dir" ]; then
		if ! _mkt_util_cd "$_mkt_latest_dir"; then
			unset -v _mkt_latest_dir
			return 1
		fi
	else
		unset -v _mkt_latest_dir
		return 1
	fi

	unset -v _mkt_latest_dir
}
_mkt_util_cd() {
	# Running 'pushd' may fail if current directory no longer exists or if in strictly POSIX environment.
	# shellcheck disable=SC3044
	if [ -d "$PWD" ] && (builtin pushd . >/dev/null); then
		if ! pushd -- "$1" >/dev/null; then
			_util_log_error "mkt: Could not pushd"
			rmdir "$_mkt_dir" 2>/dev/null
			return 1
		fi
	else
		if ! cd -- "$1"; then
			_util_log_error "mkt: Could not cd"
			rmdir "$_mkt_dir" 2>/dev/null
			return 1
		fi
	fi

	if [ -n "$_mkt_old_pwd" ]; then
		OLDPWD=$_mkt_old_pwd
	fi
}
_mkt_util_git_clone() {
	if ! git clone -- "$1"; then
		_util_log_error "mkt: Could not clone repository"
		rmdir "$_mkt_dir" 2>/dev/null
		return 1
	fi
}
_mkt_util_log() {
	printf "%s\n" "$(date '+%Y.%m.%d - %I:%M:%S') | $_mkt_dir | $1" >>"${XDG_STATE_HOME:-$HOME/.local/state}/history/mkt_history"
}

nh() {
	nohup "$@" >/dev/null 2>&1 &
}

o() {
	if [ $# -eq 0 ]; then
		xdg-open .
	else
		xdg-open "$@"
	fi
}

pbake() {
	if ! _shell_dir=$(
		while [ ! -d '.git' ] && [ "$PWD" != / ]; do
			if ! cd ..; then
				exit 1
			fi
		done
		if [ "$PWD" = / ]; then
			exit 1
		fi
		printf '%s' "$PWD"
	); then
		_util_log_error "Failed to cd to nearest Git repository" || return 1
	fi

	_shell_bakefile='.hidden/Bakefile.sh'
	if [ -f "$_shell_bakefile" ]; then
		_shell_bake=
		if command -v bake >/dev/null 2>&1; then
			_shell_bake='bake'
		else
			_shell_bake='./bake'
		fi

		_util_log_info "Using Bakefile: $PWD/$_shell_bakefile"
		"$_shell_bake" -f "$_shell_bakefile" "$@"

		unset -v _shell_bake _shell_bakefile
	else
		_util_log_error "Could not find a Bakefile under hidden directory" || return 1
	fi
}

print_shell_prompt_eval_string() {
	_file="${XDG_STATE_HOME:-${HOME:?}/.local/state}/dotfiles-shell-prompts/${1:-bash}/_${2:-starship}.txt"

	if [ ! -f "$_file" ]; then
		printf '%s\n' "File not found: $_file" >&2
		printf 'false\n'
		return 1
	fi

	cat "$_file"

	unset -v _file
}

qe() {
	filterList="BraveSoftware code tetrio-desktop obsidian discord sublime-text Ryujinx unity3d hmcl hdlauncher TabNine zettlr Zettlr Google lunarclient libreoffice VirtualBox configstore pulse obs-studio eDEX-UI 1Password kde.org sublime-text-3 gdlauncher gdlauncher_next launcher-main gitify QtProject GIMP r2modman r2modmanPlus-local Code plover GitKraken Electron bonsai-browser sidekick Insomnia Typora wavebox microsoft-edge evolution chromium"

	_qe_file=$(
		cd -- "$XDG_CONFIG_HOME" || {
			_util_log_error "qe: Could not cd"
			exit 1
		}
		filterArgs=
		for file in $filterList; do
			filterArgs="$filterArgs -o -name $file"
		done

		# shellcheck disable=SC2086
		find -L . -ignore_readdir_race \( \
			-name 'Beaker Browser' \
			$filterArgs \
			-o -name 'Helios Launcher' \
			-o -name 'Code - Insiders' \
			-o -path ./kak/plugins \
			-o -path ./kak/autoload \
			-o -path ./cookiecutter/cookiecutters \
			\) -prune -o -print | fzf
	)

	[ -z "$_qe_file" ] && {
		_util_log_error "qe: Chosen file empty"
		return 1
	}

	_qe_file="$XDG_CONFIG_HOME/$(printf "%s" "$_qe_file" | cut -c3-)"
	v "$_qe_file"
	history -s "v \"$_qe_file\""
	unset -v _qe_file
}

r() {
	for _file; do
		if [ -d "$_file" ]; then
			command rmdir "$_file"
		else
			command rm "$_file"
		fi
	done
	unset -v _file
}

# https://unix.stackexchange.com/a/123770
see_old() {
	sudo lsof +c 0 | grep 'DEL.*lib' | awk '1 { print $1 ": " $NF }' | sort -u
}

serv() {
	set -- "${1:-.}" "${2:-4000}"

	if ! [ -d "$1" ]; then
		_util_log_error "serv: Dir '$1' doesn't exist"
		return 1
	fi

	# Don't use Python's built in http.server due to weird caching issues.
	if command -v dufs >/dev/null 2>&1; then
		dufs --render-try-index --hidden '*env*' --bind '::1' --port "$2" "$1"
	elif command -v file_server >/dev/null 2>&1; then
		file_server "$1" --host 127.0.0.1 -p "$2" # deno
	elif command -v http-server >/dev/null 2>&1; then
		http-server "$1" -c-1 -a 127.0.0.1 -p "$2" # node
	else
		if _util_confirm "Would you like to install dufs?"; then
			cargo install dufs
			dufs --render-try-index --hidden '*env*' --bind '::1' --port "$2" "$1"
		else
			_util_log_error "serv: No executable found to start server"
			return 1
		fi
	fi
}

t() {
	if [ $# -eq 0 ]; then
		_util_log_error 't: Missing file arguments'
		return
	fi

	for _file; do
		mkdir -p "${_file%/*}"
		command touch "$_file"
	done
	unset -v _file
}

unchr() {
	[ -z "$1" ] && {
		_util_log_error "unchr: No mountpoint specified"
		return 1
	}
	[ -d "$1" ] || {
		_util_log_error "unchr: Folder doesn't exist"
		return 1
	}

	umount "$1/proc"
	umount "$1/sys"
	umount "$1/run"
	umount "$1/dev"
}

upgrade() {
	sudo apt update -y
	apt list --upgradable
	sudo apt upgrade -y
	sudo apt autoremove -y
	flatpak update -y
	flatpak --system update -y
}

v() {
	s=
	if [ -e "$1" ] && [ "$(stat -c "%G" "$1")" = 'root' ]; then
		s='sudo'
	fi

	_v_editor="${VISUAL:-vi}"
	if [ $# -eq 0 ]; then
		"$_v_editor" .
	else
		$s mkdir -p "${1%/*}"
		$s "$_v_editor" "$@"
	fi
	unset -v _v_editor
}

vtraceroute() {
	xdg-open "https://stefansundin.github.io/traceroute-mapper/?trace=$('traceroute' -q1 "$*" | sed ':a;N;$!ba;s/\n/%0A/g')"
}

wa() {
	watch -cn.3 "$@"
}

waf() {
	watch -cn.1 "$@"
}

# watch slow
was() {
	watch -cn1 "$@"
}
