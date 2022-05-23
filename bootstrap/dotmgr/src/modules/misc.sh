# shellcheck shell=bash

util.clone_in_dots 'https://github.com/darsain/uosc'

if [ ! -d "$XDG_DATA_HOME/tmux/plugins/tpm" ]; then
	core.print_info "Installing tpm"
	mkdir -p "$XDG_DATA_HOME/tmux/plugins"
	git clone https://github.com/tmux-plugins/tpm "$XDG_DATA_HOME/tmux/plugins/tpm"
fi
