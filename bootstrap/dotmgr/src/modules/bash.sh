# shellcheck shell=bash

# Frameworks
util.clone_in_dots 'https://github.com/ohmybash/oh-my-bash'
util.clone_in_dots 'https://github.com/bash-it/bash-it'
source ~/.dots/.repos/bash-it/install.sh --no-modify-config

# Prompts
util.clone_in_dots 'https://github.com/magicmonty/bash-git-prompt'
util.clone_in_dots 'https://github.com/riobard/bash-powerline'
util.clone_in_dots 'https://github.com/barryclark/bashstrap'
util.clone_in_dots 'https://github.com/lvv/git-prompt'
util.clone_in_dots 'https://github.com/nojhan/liquidprompt'
util.clone_in_dots 'https://github.com/arialdomartini/oh-my-git'
util.clone_in_dots 'https://github.com/twolfson/sexy-bash-prompt'

# Utilities
util.clone_in_dots 'https://github.com/akinomyoga/ble.sh'
util.clone_in_dots 'https://github.com/huyng/bashmarks'

# Unused
# util.clone 'https://github.com/basherpm/basher' ~/.dots/.repos/basher
