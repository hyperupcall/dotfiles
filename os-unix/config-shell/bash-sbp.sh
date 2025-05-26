#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

declare -g g_name='bash-sbp'
declare -g dir="$HOME/.dotfiles/.data/repos/sbp"

main() {
	helper.setup_gitrepo 'https://github.com/brujoand/sbp' "$dir"
}

launch() {
	printf '%s\n' "SBP_PATH=\"$dir\""
	printf '%s\n' "source \$SBP_PATH/sbp.bash"
}

util.if_file_sourced || _main "$@"
