#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/setup.sh

declare -g g_name='Miscellaneous Devtools'

main() {
	if ! command -v file_server &>/dev/null; then
		if command -v deno &>/dev/null; then
			deno install --allow-net --allow-read https://deno.land/std@0.145.0/http/file_server.ts
		else
			core.print_warn "Deno not installed. Skipping installation of 'file_server'"
		fi
	fi
}

installed() {
	command -v lefthook &>/dev/null
}

util.if_file_sourced || _setup "$@"
