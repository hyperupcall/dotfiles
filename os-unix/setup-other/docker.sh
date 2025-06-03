#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

declare -g g_name='Docker'

main() {
	helper.setup "$@"
}

install.ubuntu() {
	sudo apt-get -y install \
		ca-certificates \
		gnupg \
		lsb-release \
		curl # lint-ignore

	local dist='focal'
	local gpg_file="/etc/apt/keyrings/docker.asc"

	pkg.add_apt_key \
		'https://download.docker.com/linux/ubuntu/gpg' \
		"$gpg_file"

	pkg.add_apt_repository \
		'/etc/apt/sources.list.d/docker.sources' "
			Types: deb
			URIs: https://download.docker.com/linux/ubuntu
			Suites: $dist
			Components: stable
			Architectures: $(dpkg --print-architecture)
			signed-by: $gpg_file"

	sudo apt-get update -y
	sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
	sudo groupadd --force docker
	sudo usermod -aG docker "$USER"
}

installed() {
	command -v docker &>/dev/null
}

util.if_file_sourced || _main "$@"
