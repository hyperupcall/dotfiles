#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

declare -g g_name='Python Tools'

main() {
	python3 -m ensurepip --upgrade
	python3 -m pip install --upgrade pip
	python3 -m pip install --upgrade wheel
	python3 -m pip install --user pipx
	python3 -m pipx ensurepath
}

configure() {
	util.write_shellfile 'pipx' \
		--bash 'eval "$(register-python-argcomplete pipx)"' \
		--zsh 'eval "$(register-python-argcomplete pipx)"' \
		--tcsh 'eval `register-python-argcomplete --shell tcsh pipx`'
}

util.if_file_sourced || _setup "$@"
