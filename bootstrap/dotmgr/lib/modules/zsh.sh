# shellcheck shell=bash

check_bin zsh
check_bin z

[ ! -d "$XDG_DATA_HOME/oh-my-zsh" ] && {
	log_info "Installing oh-my-zsh"
	git clone https://github.com/ohmyzsh/oh-my-zsh "$XDG_DATA_HOME/oh-my-zsh"
}
