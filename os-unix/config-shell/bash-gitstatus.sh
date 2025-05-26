#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

declare -g g_name='bash-gitstatus'
declare -g dir="$HOME/.dotfiles/.data/repos/gitstatus"

main() {
	helper.setup_gitrepo 'https://github.com/romkatv/gitstatus' "$dir"
}

launch() {
	printf '%s\n' "export GITSTATUS_DIR=\"$dir/gitstatus.plugin.sh\""
	cat "$dir/gitstatus.prompt.sh"
}

util.if_file_sourced || _main "$@"
