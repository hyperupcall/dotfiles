# shellcheck shell=sh

cd() {
	case "$1" in
	mov)
		cd /storage/vault/rodinia/Media-Movies || _shell_util_die "Could not cd to '$1'"
		return ;;
	ser)
		cd /storage/vault/rodinia/Media-Series || _shell_util_die "Could not cd to '$1'"
		return ;;
	esac

	autoenv_init
	command cd "$@" || _shell_util_die "Could not cd to '$1'"
}

cp() {
	if command -v rsync >/dev/null 2>&1 && {
		[ -n "$BASH_VERSION" ] || [ -n "$ZSH_VERSION" ]
	}; then
		# TODO: is needed?
		# for arg; do
		# 	case "$arg" in
		# 	-*)
		# 		_shell_util_die "cp: Options not accepted. Please use the 'cp' binary if necessary"
		# 		return
		# 	esac
		# done

		# if [ $# -eq 2 ] && [ -d "$1" ]; then
		# 	# When one of the arguments to 'cp' or 'rsync' is
		# 	# a directory, behavior is different. 'cp' copies
		# 	# the contents of the directory to dest. 'rsync'
		# 	# copies the directory itself to dest. To fix this,
		# 	# we change the arg so that the directory ends in
		# 	# "/.", accounting for a user-placed slash suffix
		# 	# By doing this, rsync knows to copy the files in
		# 	# the directory, rather than the directory itself

		# 	# shellcheck disable=SC3057
		# 	if [ "${1: -1}" = "/" ]; then
		# 		# shellcheck disable=SC3030,SC3024
		# 		f="$1."
		# 	else
		# 		# shellcheck disable=SC3030,SC3024
		# 		f="$1/."
		# 	fi

		# 	command rsync -ah --info flist2,name,progress,symsafe "$f" "$2"
		# 	return
		# fi

		# shellcheck disable=SC3054
		command rsync -ah --info flist2,name,progress,symsafe "$@"
	else
		_shell_util_log_warn "cp: Falling back to 'cp'"
		command cp -iv "$@"
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

# clone(user, root)
lsblk() {
	if [ $# -eq 1 ] && [ "$1" = "-f" ]; then
		command lsblk -o NAME,FSUSED,FSAVAIL,FSSIZE,FSUSE%,FSTYPE,MOUNTPOINT
	else
		command lsblk "$@"
	fi
}

# remake, mmake
make() {
	if command -v >/dev/null 2>&1 colormake; then
		colormake "$@"
	else
		_shell_util_log_warn "'colormake' not installed"
		command make "$@"
	fi
}
# see 'yay' comment
# pacman() {
# # shellcheck disable=SC2154
# 	temp="$PATH"

# 	# shellcheck disable=SC2154
# 	PATH="$_path_original_saved"

# 	pacman --color=auto "$@"

# 	PATH="$temp"
# }

# # see 'yay' comment
# paru() {
# # shellcheck disable=SC2154
# 	temp="$PATH"

# 	# shellcheck disable=SC2154
# 	PATH="$_path_original_saved"

# 	paru --color=auto "$@"

# 	PATH="$temp"
# }

ping() {
	if command -v prettyping >/dev/null 2>&1; then
		prettyping "$@"
	else
		command ping "$@"
	fi
}

# TODO
#_stty_saved_settings="$(stty -g)"
stty() {
	if [ $# -eq 1 ] && [ "$1" = "sane" ]; then
		# 'stty sane' resets our modifications to behaviors of tty device
		# including the line discipline. this assumes tty was sane when initialized
		stty "$_stty_saved_settings"
		_stty_exit_code=$?

		# redirect log to error since this could be a scripted command used within a tty
		_shell_util_log_info "stty: Restored stty settings to our defaults" 1>&2

		return "$_stty_exit_code"
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

# packages keep installing to /home/edwin/data/miniconda or /home/edwin/data/pyenv
# switch out path to system python is used. pacman hook doesn't work with something
# that's shell specific or isn't generic. TODO: see if there's a better workaround
# yay() {
# 	# shellcheck disable=SC2154
# 	temp="$PATH"

# 	# shellcheck disable=SC2154
# 	PATH="$_path_original_saved"

# 	yay --color=auto "$@"

# 	PATH="$temp"
# }
