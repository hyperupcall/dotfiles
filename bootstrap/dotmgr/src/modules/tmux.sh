# shellcheck shell=bash

if [ ! -d "$XDG_DATA_HOME/tmux/plugins/tpm" ]; then
	print.info "Installing tpm"
	mkdir -p "$XDG_DATA_HOME/tmux/plugins"
	git clone https://github.com/tmux-plugins/tpm "$XDG_DATA_HOME/tmux/plugins/tpm"
fi
