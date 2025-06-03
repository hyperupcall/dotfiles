#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

declare -g g_name='direnv'

main() {
	mise install cmake@latest
	mise use -g cmake@latest
}

configure() {
	util.write_shellfile 'direnv' \
		--bash 'eval "$(direnv hook bash)"' \
		--zsh 'eval "$(direnv hook bash)"' \
		--fish 'direnv hook fish | source' \
		--tcsh 'eval `direnv hook tcsh`'
}

util.if_file_sourced || _main "$@"
