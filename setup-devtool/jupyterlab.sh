#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='JupyterLab'

install.any() {
	uv tool install jupyterlab --with pip

	brew services start jupyterlab
}

install.installed() {
	command -v jupyter-lab &>/dev/null
}

util.if_file_sourced || _setup "$@"
