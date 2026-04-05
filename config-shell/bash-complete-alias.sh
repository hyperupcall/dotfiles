#!/usr/bin/env bash
source ~/.dotfiles/data/setup.sh

declare -g g_name='complete-alias'

configure() {
	util.write_shellfile 'bash-complete-alias' \
		--bash \
	'for alias_name in $(
		alias -p | while IFS= read -r line; do
			line="${line#alias }"
			line="${line%%=*}"
			printf "%s\n" "$line"
		done
	); do
		complete -F _complete_alias "$alias_name"
	done; unset -v alias_name'
}
