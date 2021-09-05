# shellcheck shell=sh

# get the most recent file in a directory
_mkt_util_get_latest_file() {
	find . -mindepth 1 -maxdepth 1 -type f -printf "%T@\t%p\0" \
			| sort -zn | cut -z -f2- | tail -z -n1 | tr -d '\000'
}

# cd into the most recently created directory
_mkt_util_cd_latest_dir() {
	latestDir="$(
		find . -mindepth 1 -maxdepth 1 -type d -printf "%T@\t%p\0" \
				| sort -zn | cut -z -f2- | tail -z -n1 | tr -d '\000'
	)"

	[ -n "$latestDir" ] && {
		_mkt_util_cd "$latestDir" || return
	}
}

# For pOsIX coMplIanCe since pushd isn't POSIX
_mkt_util_cd() {
	# shellcheck disable=SC3044
	if (builtin pushd . >/dev/null); then
		pushd "$1" >/dev/null || { _shell_util_die "mkt: Could not pushd"; rmdir "$dir" 2>/dev/null; return; }
	else
		cd "$1" || { _shell_util_die "mkt: Could not cd"; rmdir "$dir" 2>/dev/null; return; }
	fi
}

_mkt_util_ensure_cd() {
	if ! cd -- "$1"; then
		_shell_util_die "mkt: Could not cd"
		rmdir "$1" 2>/dev/null
		return 1
	fi
}

_mkt_util_log() {
	echo donee
	printf "%s\n" "$(date '+%b %d - %I:%M:%S') | $dir | $1" >> "$XDG_STATE_HOME/history/mkt_history"
}

_mkt_util_git_clone() {
	if [ "$_mkt_flag_shallow" = "yes" ]; then
		git clone -- "$1" || { _shell_util_die "mkt: Could not clone repository"; rmdir "$dir" >/dev/null 2>&1; return; }
	else
		# _mkt_default_branch="$(
		# 	git ls-remote --symref "$1" HEAD | awk '{ if(NR==1) print $2 }' | awk -F '/' '{ print $NF }'
		# )"

		git clone --depth=1 --single-branch -- "$1"

		# unset -v _mkt_default_branch
	fi
}

mkt() {
	_mkt_flag_shallow='no'
	arg=

	for arg; do case "$arg" in
	--help)
		cat <<-EOF
		mkt

		Flags:
		  --shallow
		    When git cloning a repository, only clone from HEAD ref

		Examples:
		  mkt https://github.com/eankeen/dots
		  mkt --shallow eankeen/dots
		  mkt https://releases.hashicorp.com/packer/1.7.2/packer_1.7.2_linux_amd64.zip
		EOF
		return
		;;
	--shallow)
		_mkt_flag_shallow=yes
		;;
	-*)
		_shell_util_die "mkt: Flag '$arg' not recognized"
		return
		;;
	*)
		_mkt_arg="$arg"
		;;
	esac done
	unset -v arg

	set -- "$_mkt_arg"

	case "$1" in
	# nothing passed
	'')
		dir="$(mktemp -d)"
		_mkt_util_ensure_cd "$dir"
		_mkt_util_log "$1"
		;;
	# remote files
	https://*/*.*)
		dir="$(mktemp -d)"
		_mkt_util_ensure_cd "$dir"
		_mkt_util_log "$1"

		command curl -LO "$1" || { _shell_util_die "mkt: Could not fetch resource with cURL"; return; }
		_mkt_latest_file="$(_mkt_util_get_latest_file)"
		if file "$_mkt_latest_file" | grep -Eq '(compressed|archive)'; then
			if command -v aunpack >/dev/null 2>&1; then
				aunpack "$_mkt_latest_file" # uncompress if compressed
			else
				_shell_util_ls
				_shell_util_die "mkt: Command aunpack not found"
				return
			fi
		fi

		_mkt_util_cd_latest_dir || return
		_shell_util_ls
		unset -v _mkt_latest_file
		;;
	# git repository
	git@*|git://*|*.git|https://github.com/*|https://gitlab.com/*|https://git.sr.ht/*|https://*@bitbucket.org/*|https://invent.kde.org/*)
		_mkt_id="$(printf '%s\n' "$1" | rev | cut -d/ -f1 | rev)" # id so we can see this folder in /tmp easier
		dir="$(mktemp -d --suffix "-$_mkt_id")"
		_mkt_util_ensure_cd "$dir"
		_mkt_util_log "$1"

		_mkt_util_git_clone "$1" || return

		_mkt_util_cd_latest_dir || return
		_shell_util_ls
		unset -v _mkt_id
		;;
	# file path
	/*|./*)
		_mkt_id="$(printf '%s\n' "$1" | rev | cut -d/ -f1 | rev)" # id so we can see this folder in /tmp easier
		dir="$(mktemp -d --suffix "-$_mkt_id")"
		_mkt_util_ensure_cd "$dir"
		_mkt_util_log "$1"

		if [ -f "$1" ] || [ -d "$1" ]; then
			command cp -r "$1" "$dir"
			_mkt_util_cd "$dir"
		else
			_mkt_util_cd "$dir"
		fi
		;;
	# github repository shorthand
	*/*)
		_mkt_id="$(printf '%s\n' "$1" | rev | cut -d/ -f1 | rev)" # id so we can see this folder in /tmp easier
		dir="$(mktemp -d --suffix "-$_mkt_id")"
		_mkt_util_ensure_cd "$dir"
		_mkt_util_log "$1"

		_mkt_util_git_clone "https://github.com/$1" || return

		_mkt_util_cd_latest_dir || return
		_shell_util_ls
		unset -v _mkt_id
		;;
	*)
		dir="$(mktemp -d --suffix "-$1")"

		if [ -f "$1" ] || [ -d "$1" ]; then
			command cp -r "$1" "$dir"
		fi

		_mkt_util_ensure_cd "$dir"
		_mkt_util_log "$1"
		;;
	esac

	unset -v _mkt_flag_shallow _mkt_arg dir
}
