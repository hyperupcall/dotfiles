#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='kcomplete-alias'
declare -g g_dir="$HOME/.dotfiles/.data/repos/kcomplete-alias"

install.any() {
	util.clone "$g_dir" 'https://github.com/hyperupcall-projects/kcomplete-alias'
}

install.configure() {
	util.write_shellfile 'bash-kcomplete-alias' \
		--bash '
			source "'"$g_dir"'/complete_alias"
			for alias_name in $(
				alias -p | while IFS= read -r line; do
					line="${line#alias }"
					line="${line%%=*}"
					printf "%s\n" "$line"
				done
			); do
				complete -F _complete_alias "$alias_name"
			done; unset -v alias_name'
}

install.installed() {
	[ -d "$g_dir" ]
}

util.if_file_sourced || _setup "$@"
