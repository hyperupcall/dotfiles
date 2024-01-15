#!/usr/bin/env bash

source "${0%/*}/../source.sh"

# TODO: hub.woof
# TODO: git smuge etc filters are in use
# TODO: minimum Git version of 2.37.0 for 'push.autoSetupRemote'
main() {
	printf '%s\n' "GIT:"
	check.command 'spaceman-diff'
	check.command 'npm-merge-driver'
	check.command 'yarn-merge-driver'
	printf '%s\n'

	printf '%s\n' "BINARIES:"
	check.command dotmgr
	check.command dotdrop
	check.command clang-format
	check.command clang-tidy
	check.command bake
	check.command basalt
	printf '\n'

	printf '%s\n' "BINARIES: DEVELOPMENT:"
	check.command gh
	check.command nvim
	check.command just
	check.command 'dufs'
	printf '\n'

	printf '%s\n' "DROPBOX:"
	check.process dropbox
	printf '\n'

	printf '%s\n' "FISH:"
	check.command fish
	check.command fish-indent
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
	find ~/.ssh/ ~/.gnupg/ -type d -exec chmod 700 {} \;
	find ~/.ssh/ ~/.gnupg/ -type f -exec chmod 600 {} \;
}

success() {
	printf '%s\n' "✅ $1"
}

failure() {
	printf '%s\n' "⛔ $1"
}

check.command() {
	local cmd="$1"

	if util.is_cmd "$cmd"; then
				success "Is installed: $cmd"
	else
		failure "Not installed: $cmd"
	fi
}

check.process() {
	local process="$1"

	if pgrep "$process" &>/dev/null; then
		success "$process is running"
	else
		if (($? == 1)); then
			failure "$process not installed"
		else
			failure "Syntax or memory error when calling pgrep"
		fi
	fi
}

main "$@"
