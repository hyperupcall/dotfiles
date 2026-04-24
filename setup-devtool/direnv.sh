#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='direnv'

install.any() {
	mise install direnv@latest
	mise use -g direnv@latest
}

installed() {
	command -v direnv &>/dev/null
}

configure() {
	util.write_shellfile 'direnv' \
		--bash 'eval "$(direnv hook bash)"' \
		--zsh 'eval "$(direnv hook bash)"' \
		--fish 'direnv hook fish | source' \
		--tcsh 'eval `direnv hook tcsh`'
}

util.if_file_sourced || _setup "$@"
