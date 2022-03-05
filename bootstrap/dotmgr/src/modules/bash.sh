# shellcheck shell=bash

if [ ! -d "$XDG_DATA_HOME/bash-it" ]; then
	print.info "Installing bash-it"
	git clone 'https://github.com/bash-it/bash-it' ~/.dots/.repos/bash-it
	source "$XDG_DATA_HOME/bash-it/install.sh" --no-modify-config
fi

if [ ! -d "$XDG_DATA_HOME/oh-my-bash" ]; then
	print.info "Installing oh-my-bash"
	git clone 'https://github.com/ohmybash/oh-my-bash' ~/.dots/.repos/oh-my-bash
fi

if [ ! -d "$XDG_DATA_HOME/bash-git-prompt" ]; then
	print.info "Installing bash-git-prompt"
	git clone 'https://github.com/magicmonty/bash-git-prompt' ~/.dots/.repos/bash-git-prompt
fi

if [ ! -d "$XDG_DATA_HOME/bashmarks" ]; then
	print.info "Installing bookmarks.sh"
	git clone 'https://github.com/huyng/bashmarks' ~/.dots/.repos/bashmarks
fi

if [ ! -d  "$XDG_DATA_HOME/basher" ]; then
	print.info "Installing basher"
	git clone 'https://github.com/basherpm/basher' ~/.dots/.repos/basher
fi
