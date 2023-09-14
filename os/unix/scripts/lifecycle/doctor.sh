#!/usr/bin/env bash

# Name:
# Doctor
#
# Description:
# Does a doctor

source "${0%/*}/../source.sh"

success() {
	printf '%s\n' "✅ $1"
}

failure() {
	printf '%s\n' "⛔ $1"
}

main() {
	printf '%s\n' "BINARIES:"
	local -a cmds=(dotmgr dotdrop clang-format clang-tidy)
	local cmd=
	for cmd in "${cmds[@]}"; do
		if util.is_cmd "$cmd"; then
			success "Is installed: $cmd"
		else
			failure "Not installed: $cmd"
		fi
	done; unset -v cmd
	printf '\n'

	printf '%s\n' "DROPBOX:"
	if pgrep dropbox &>/dev/null; then
		success "Dropbox is running"
	else
		if (($? == 1)); then
			failure "Dropbox not installed"
		else
			failure "Syntax or memory error when calling pgrep"
		fi
	fi
	printf '\n'

	printf '%s\n' "SENSITIVE:"
	if [ -d "$XDG_DATA_HOME/password-store" ]; then
		if [ -d "$XDG_DATA_HOME/password-store" ]; then
			success "Has password-store and is git directory"
		else
			failure "Password-store not a git directory"
		fi
	else
		failure "Password-store not found in the correct location"
	fi
	if gpg --list-keys 0x2FB93BF35E14E7C4 &>/dev/null; then
		success "Has password-store gpg public key"
	else
		success "Does not have password-store gpg public key"
	fi
	if gpg --list-keys 0x3851E5FD042C7C6C &>/dev/null; then
		success "Has commit signing gpg public key"
	else
		success "Does not have commit signing gpg public key"
	fi
	if [ -f ~/.ssh/github ]; then
		success "Has GitHub private SSH key"
	else
		success "Does not have GitHub private SSH key"
	fi
}

main "$@"