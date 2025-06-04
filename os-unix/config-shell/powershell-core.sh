#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

declare -g g_name='PowerShell Core'

main() {
	util.install_by_setup "$@"
}

install.debian() {
	local gpg_file="/etc/apt/keyrings/microsoft.asc"
	local dist='bullseye'

	pkg.add_apt_key \
		'https://packages.microsoft.com/keys/microsoft.asc' \
		"$gpg_file"

	pkg.add_apt_repository \
		'/etc/apt/sources.list.d/microsoft.sources' "
			Types: deb
			URIs: https://packages.microsoft.com/repos/microsoft-debian-$dist-prod
			Suites: $dist
			Components: main
			Architectures: $(dpkg --print-architecture)
			signed-by: $gpg_file"


	sudo apt-get -y update
	sudo apt-get -y install powershell
}

util.if_file_sourced || _setup "$@"
