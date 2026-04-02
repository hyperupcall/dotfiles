#!/usr/bin/env bash
source ~/.dotfiles/os-unix/data/setup.sh

declare -g g_name='pnpm dependencies'
declare -g g_dependencies=(yarn ovsx @vscode/vsce)

install.any() {
	npm i -g pnpm
	pnpm i -g "${g_dependencies[@]}"
}

installed() {
	command -v pnpm &>/dev/null
	
	pnpm list --parseable -g --depth=0 | awk -v deps="${g_dependencies[*]}" '
		BEGIN {
			n = split(deps, arr, " ")
			for (i = 1; i <= n; i++) {
				needed_dependencies[arr[i]] = 1
			}
		}
		{
			sub(/.*\/node_modules\//, "", $0)
			installed[$0] = 1
		}
		END {
			for (dep in needed_dependencies) {
				if (!(dep in installed)) {
					err = 1
				}
			}
			exit err
		}
	'
}

util.if_file_sourced || _setup "$@"
