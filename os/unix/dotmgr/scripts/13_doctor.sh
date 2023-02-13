# shellcheck shell=bash

# Name:
# Doctor
#
# Description:
# Does a doctor

main() {
	local -a cmds=(clang-format clang-tidy)
	local cmd=
	for cmd in "${cmds[@]}"; do
		if ! util.is_cmd "$cmd"; then
			core.print_warn "Not installed: $cmd"
		fi
	done; unset -v cmd

	# Here, test if various processes and daemons are running like they are supposed to
	# Maybe verify if certain shortcuts exist or certain binaries are in the PATH (of either interactive or non-interactive apps)

	# TEST gpg decryption for a set of keys
	# TODO: test if password-store is a git directory and is up to date
	# IF dropbox is on and syncing
	printf '%s\n' 'Done.'
}

main "$@"
