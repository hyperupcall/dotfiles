#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/setup.sh

declare -g g_name='Antigravity'

main() {
	util.install_by_setup "$@"
}

install.ubuntu() {
	local gpg_file="/etc/apt/keyrings/antigravity-repo-key.asc"

	pkg.add_apt_key 'https://us-central1-apt.pkg.dev/doc/repo-signing-key.gpg' \
		"$gpg_file"

	pkg.add_apt_repository \
		'/etc/apt/sources.list.d/antigravity.sources' "
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
	command -v antigravity &>/dev/null
}

util.if_file_sourced || _setup "$@"
