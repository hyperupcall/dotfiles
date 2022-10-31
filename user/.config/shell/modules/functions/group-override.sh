# shellcheck shell=sh

cd() {
	# Ex. New mountpoints
	if [ "$1" = '.' ]; then
		# shellcheck disable=SC2164
		cd -- "$PWD"
	fi

	if command -v autoenv_init >/dev/null 2>&1; then
		autoenv_init
	else
		_shell_util_log_warn "cd: Function is not defined: autoenv_init"
	fi

	if command -v __woof_cd_hook >/dev/null 2>&1; then
		__woof_cd_hook
	else
		_shell_util_log_warn "cd: Function is not defined: __woof_cd_hook"
	fi
	
	local dir=
	for arg; do case $arg in
		-*) ;;
		*) dir=$arg ;;
	esac done

	builtin cd "$@" || _shell_util_die "cd: cd to '$dir' failed with code $?"

	if [ -f 'foxxo.toml' ] || [ -f 'foxxy.toml' ] || [ -f 'fox.json' ]; then
		if command -v deno >/dev/null 2>&1; then
			if command -v foxxo >/dev/null 2>&1; then
				foxxo lint --fix
			else
				_shell_util_log_warn "cd: Command not found: foxxo"
			fi
		else
			_shell_util_log_warn "cd: Command not found: deno"
		fi
	fi
}

# clone(user)
curl() {
	if command -v curlie >/dev/null 2>&1; then
		curlie "$@"
	else
		command curl "$@"
	fi
}

__shell_lsblk_can_mountpoints=no
if [ -z "$__shell_lsblk_can_mountpoints" ]; then
	__shell_lsblk_tmp=$(command lsblk --version)
	__shell_lsblk_major_num=${__shell_lsblk_tmp##* }; __shell_lsblk_major_num=${__shell_lsblk_major_num%%.*}
	__shell_lsblk_minor_num=${__shell_lsblk_tmp##*.}; __shell_lsblk_minor_num=${__shell_lsblk_minor_num%%.*}
	if [ "$__shell_lsblk_major_num" -ge 3 ] || \
		{ [ "$__shell_lsblk_major_num" -eq 2 ] && [ "$__shell_lsblk_minor_num" -ge 37 ]; }; then
		___shell_lsblk_can_mountpoints=yes
	fi
	unset -v __shell_lsblk_tmp __shell_lsblk_major_num __shell_lsblk_minor_num
fi
lsblk() {
	__str='MOUNTPOINT'
	if [ "$___shell_lsblk_can_mountpoints" = 'yes' ]; then
		__str='MOUNTPOINTS'
	fi

	if [ $# -eq 1 ] && [ "$1" = "-f" ]; then
		command lsblk -o "NAME,FSUSED,FSAVAIL,FSSIZE,FSUSE%,FSTYPE,$__str,UUID,MODEL"
	elif [ $# -eq 0 ]; then
		command lsblk -o "NAME,SIZE,TYPE,$__str,PARTUUID,MODEL"
	else
		command lsblk "$@"
	fi

	unset -v __str
}

ping() {
	if command -v prettyping >/dev/null 2>&1; then
		prettyping "$@"
	else
		command ping "$@"
	fi
}

if [ -t 0 ]; then
	_stty_saved_settings=$(stty -g)
fi
stty() {
	if [ $# -eq 1 ] && [ "$1" = 'sane' ]; then
		# 'stty sane' resets our modifications to behaviors of tty device
		# including the line discipline. This assumes tty was sane when initialized
		if [ -n "$_stty_saved_settings" ]; then
			stty "$_stty_saved_settings"
			_stty_exit_code=$?

			# redirect log to error since this could be a scripted command used within a tty
			_shell_util_log_info "stty: Restored stty settings to our defaults" >&2
		else
			command stty sane
			_stty_exit_code=$?

			_shell_util_log_warn "stty: Variable \$_stty_saved_settings empty. Falling back to 'stty sane'" >&2
		fi

		return $_stty_exit_code
	else
		command stty "$@"
	fi
}

# clone(user, root)
unlink() {
	for arg; do
		case "$arg" in
		--help|--version)
			command unlink "$@"
			return
			;;
		esac
	done

	for file; do
		command unlink "$file"
	done

	unset -v arg file
}
