# shellcheck shell=bash

util.ensure_bin zsh
util.ensure_bin z

[ ! -d "$XDG_DATA_HOME/oh-my-zsh" ] && {
	print.info "Installing oh-my-zsh"
	git clone https://github.com/ohmyzsh/oh-my-zsh "$XDG_DATA_HOME/oh-my-zsh"
}
