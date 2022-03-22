# shellcheck shell=bash

util.clone 'https://github.com/ohmybash/oh-my-bash' ~/.dots/.repos/oh-my-bash
if [ ! -d "$XDG_DATA_HOME/bash-it" ]; then
	util.clone 'https://github.com/bash-it/bash-it' ~/.dots/.repos/bash-it
	source "$XDG_DATA_HOME/bash-it/install.sh" --no-modify-config
fi
util.clone 'https://github.com/akinomyoga/ble.sh' ~/.dots/.repos/ble.sh

util.clone 'https://github.com/magicmonty/bash-git-prompt' ~/.dots/.repos/bash-git-prompt
util.clone 'https://github.com/huyng/bashmarks' ~/.dots/.repos/bashmarks
util.clone 'https://github.com/basherpm/basher' ~/.dots/.repos/basher
