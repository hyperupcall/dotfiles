#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

declare -g g_name='Python Tools'

main() {
	helper.setup "$@"
}

install.any() {
	:
}

configure() {
	util.write_shellfile 'pipx' \
		--bash 'eval "$(zoxide init bash)"' \
		--zsh 'eval "$(zoxide init zsh)"' \
		--sh 'eval "$(zoxide init posix --hook prompt)"' \
		--fish 'zoxide init fish | source' \
		--elvish 'eval (zoxide init elvish | slurp)'
}

util.if_file_sourced || _main "$@"
