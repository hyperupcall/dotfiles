#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='gh'

install.any() {
	util.get_latest_github_release 'cli/cli'
	local version="$REPLY"
	version=${version#v}

	curl -K "$CURL_CONFIG" -o 'gh.tar.gz' "https://github.com/cli/cli/releases/download/v$version/gh_${version}_linux_amd64.tar.gz"
	tar xf 'gh.tar.gz'
	install -Dm755 "gh_${version}_linux_amd64/bin/gh" ~/.local/bin/gh
	install -Dm644 "gh_${version}_linux_amd64/share/man/man1"/* -t "$XDG_DATA_HOME/man/man1"

	rm 'gh.tar.gz'
	rm -rf "gh_${version}_linux_amd64"

	~/.local/bin/gh extension install github/gh-actions-lock
}

install.installed() {
	command -v gh &>/dev/null
}

util.if_file_sourced || _setup "$@"
