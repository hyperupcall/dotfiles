#!/usr/bin/env bash
source ~/.dotfiles/data/setup.sh

declare -g g_name='Antigravity'
declare -g g_sources_file='/etc/apt/sources.list.d/antigravity.sources'

install.ubuntu() {
	local gpg_file="/etc/apt/keyrings/antigravity-repo-key.asc"

	pkg.add_apt_key 'https://us-central1-apt.pkg.dev/doc/repo-signing-key.gpg' \
		"$gpg_file"

	pkg.add_apt_repository \
		"$g_sources_file" "
			Types: deb
			URIs: https://us-central1-apt.pkg.dev/projects/antigravity-auto-updater-dev/
			Suites: antigravity-debian
			Components: main
			Architectures: $(dpkg --print-architecture)
			signed-by: $gpg_file"

	sudo apt-get update -y
	sudo apt-get install -y antigravity
}

installed() {
	[ -f "$g_sources_file" ] && command -v antigravity &>/dev/null
}

util.if_file_sourced || _setup "$@"
