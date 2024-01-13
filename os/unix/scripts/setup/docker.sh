#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	if util.confirm 'Install Docker?'; then
		install.docker
	fi
}

install.docker() {
	sudo apt-get -y update

	sudo apt-get -y install \
		ca-certificates \
		curl \
		gnupg \
		lsb-release

	local dist='jammy'
	local gpg_file="/etc/apt/keyrings/docker.gpg"

	pkg.add_apt_key \
		'https://download.docker.com/linux/ubuntu/gpgcu' \
		"$gpg_file"

	pkg.add_apt_repository \
		"deb [arch=$(dpkg --print-architecture) signed-by=$gpg_file] https://download.docker.com/linux/ubuntu $dist stable" \
		'/etc/apt/sources.list.d/docker.list'

	sudo apt-get update
	sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
}

main "$@"
