# shellcheck shell=sh

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
