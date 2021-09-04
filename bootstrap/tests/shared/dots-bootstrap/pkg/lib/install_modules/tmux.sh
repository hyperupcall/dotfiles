# shellcheck shell=bash

check_bin tmux

[ ! -d "$XDG_DATA_HOME/tmux/plugins/tpm" ] && {
	log_info "Installing tpm"
	mkdir -p "$XDG_DATA_HOME/tmux/plugins"
	git clone https://github.com/tmux-plugins/tpm "$XDG_DATA_HOME/tmux/plugins/tpm"
}
