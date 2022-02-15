# shellcheck shell=bash

util.ensure_bin bash
util.ensure_bin dash
util.ensure_bin bats
util.ensure_bin basher

[ ! -d "$XDG_DATA_HOME/bash-it" ] && {
	util.log_info "Installing bash-it"
	git clone "https://github.com/bash-it/bash-it" "$XDG_DATA_HOME/bash-it"
	source "$XDG_DATA_HOME/bash-it/install.sh" --no-modify-config
}

[ ! -d "$XDG_DATA_HOME/oh-my-bash" ] && {
	util.log_info "Installing oh-my-bash"
	git clone "https://github.com/ohmybash/oh-my-bash" "$XDG_DATA_HOME/oh-my-bash"
}

[ ! -d "$XDG_DATA_HOME/bash-git-prompt" ] && {
	util.log_info "Installing bash-git-prompt"
	git clone "https://github.com/magicmonty/bash-git-prompt" "$XDG_DATA_HOME/bash-git-prompt"
}

[ ! -d "$XDG_DATA_HOME/bashmarks" ] && {
	util.log_info "Installing bookmarks.sh"
	git clone "https://github.com/huyng/bashmarks" "$XDG_DATA_HOME/bashmarks"
}

[ ! -d  "$XDG_DATA_HOME/basher" ] && {
	util.log_info "Installing basher"
	git clone https://github.com/basherpm/basher "$XDG_DATA_HOME/basher"
}
