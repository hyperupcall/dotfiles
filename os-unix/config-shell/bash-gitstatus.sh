#!/usr/bin/env bash
source ~/.dotfiles/os-unix/data/setup.sh

declare -g g_name='bash-gitstatus'
declare -g g_dir="$HOME/.dotfiles/.data/repos/gitstatus"

main() {
	util.clone "$g_dir" 'https://github.com/romkatv/gitstatus'
}

launch() {
	printf '%s\n' "export GITSTATUS_DIR=\"$g_dir/gitstatus.plugin.sh\""
	cat "$g_dir/gitstatus.prompt.sh"
}

util.if_file_sourced || _setup "$@"
