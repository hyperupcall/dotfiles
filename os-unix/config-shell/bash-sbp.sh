#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

declare -g g_name='bash-sbp'
declare -g g_dir="$HOME/.dotfiles/.data/repos/sbp"

main() {
	util.clone "$g_dir" 'https://github.com/brujoand/sbp'
}

launch() {
	printf '%s\n' "SBP_PATH=\"$g_dir\""
	printf '%s\n' "source \$SBP_PATH/sbp.bash"
}

util.if_file_sourced || _main "$@"
