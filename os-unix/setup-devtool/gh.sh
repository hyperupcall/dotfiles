#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/setup.sh

declare -g g_name='gh'

main() {
	util.get_latest_github_tag 'cli/cli'
	local version="$REPLY"
	version=${version#v}

	curl -K "$CURL_CONFIG" -o 'gh.tar.gz' "https://github.com/cli/cli/releases/download/v$version/gh_${version}_linux_amd64.tar.gz"
	tar xf 'gh.tar.gz'
	cp "gh_${version}_linux_amd64/bin/gh" ~/.local/bin
	mkdir -p "$XDG_DATA_HOME/man/man1"
	cp -f "gh_${version}_linux_amd64/share/man/man1"/* "$XDG_DATA_HOME/man/man1"

	rm 'gh.tar.gz'
	rm -rf "gh_${version}_linux_amd64"
}

installed() {
	command -v gh &>/dev/null
}

util.if_file_sourced || _setup "$@"
