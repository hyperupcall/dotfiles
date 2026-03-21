#!/usr/bin/env bash
source ~/.dotfiles/os-unix/data/setup.sh

declare -g g_name='LLVM'
declare -g g_sources_file='/etc/apt/sources.list.d/llvm.sources'

main() {
	util.install_by_setup "$@"
}

install.debian() {
	local dist=
	dist=$(lsb_release --codename --short)

	util.get_latest_github_tag 'llvm/llvm-project'
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
	sudo apt-get -y install clang-17
}

install.ubuntu() {
	install.debian "$@"
}

installed() {
	[ -f "$g_sources_file" ] && command -v clang &>/dev/null
}

util.if_file_sourced || _setup "$@"
