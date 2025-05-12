#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

declare -g g_name='Deno'

main() {
	helper.setup "$@"
}

install.any() {
	curl -K "$CURL_CONFIG" https://deno.land/install.sh | DENO_INSTALL="$PWD" sh

	if ! command -v file_server &>/dev/null; then # TODO
		if command -v deno &>/dev/null; then
			deno install --allow-net --allow-read https://deno.land/std@0.145.0/http/file_server.ts
		else
			core.print_warn "Deno not installed. Skipping installation of 'file_server'"
		fi
	fi
}

installed() {
	command -v deno
}

util.if_file_sourced || helper.run_main "$@"
