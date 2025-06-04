#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

declare -g g_name='LLVM'

main() {
	util.install_by_setup "$@"
}

install.debian() {
	local dist='jammy'
	local version='17'
	local gpg_file="/etc/apt/keyrings/apt.llvm.org.asc"

	pkg.add_apt_key \
		'https://apt.llvm.org/llvm-snapshot.gpg.key' \
		"$gpg_file"

	pkg.add_apt_repository \
		'/etc/apt/sources.list.d/llvm.sources' "
			Types: deb deb-src
			URIs: http://apt.llvm.org/$dist/ llvm-toolchain-$dist-$version
			Suites: main
			Components:
			Architectures: $(dpkg --print-architecture)
			signed-by: $gpg_file"

	sudo apt-get -y update
	sudo apt-get -y install clang-17
}

util.if_file_sourced || _setup "$@"
