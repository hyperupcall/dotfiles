#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='LLVM Nightly'
declare -g g_sources_file='/etc/apt/sources.list.d/llvm.sources'

install.debian() {
	local dist=
	dist=$(lsb_release --codename --short)

	util.get_latest_github_release 'llvm/llvm-project'
	local version=$REPLY
	version=${version#llvmorg-}
	version=${version%%.*}
	local gpg_file="/etc/apt/keyrings/apt.llvm.org.asc"

	pkg.add_apt_key \
		'https://apt.llvm.org/llvm-snapshot.gpg.key' \
		"$gpg_file"

	pkg.add_apt_repository \
		"$g_sources_file" "
			Types: deb deb-src
			URIs: http://apt.llvm.org/$dist/
			Suites: llvm-toolchain-$dist-$version
			Components: main
			Architectures: $(dpkg --print-architecture)
			signed-by: $gpg_file"

	sudo apt-get -y update
	sudo apt-get -y install clang-22 clangd-22 clang-format-22 clang-tidy-22
}

install.ubuntu() {
	install.debian "$@"
}

install.installed() {
	[ -f "$g_sources_file" ] && command -v clang &>/dev/null && command -v clangd &>/dev/null && command -v clang-format &>/dev/null && command -v clang-tidy &>/dev/null
}

util.if_file_sourced || _setup "$@"
