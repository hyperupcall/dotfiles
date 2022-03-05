# shellcheck shell=bash

if [ ! -d "$XDG_DATA_HOME/oh-my-zsh" ]; then
	print.info "Installing oh-my-zsh"
	git clone 'https://github.com/ohmyzsh/oh-my-zsh' ~/.dots/.repos/oh-my-zsh
fi
