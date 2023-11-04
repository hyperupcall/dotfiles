#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	if util.confirm 'Install LLVM?'; then
		install.llvm
	fi
}

install.llvm() {
	util.get_package_manager
	local pkgmngr="$REPLY"

	case $pkgmngr in
	apt)
		local dist='jammy'
		local version='17'
		local gpg_file="/etc/apt/keyrings/apt.llvm.org.asc"

		pkg.add_apt_key \
			'https://apt.llvm.org/llvm-snapshot.gpg.key' \
			"$gpg_file"

		pkg.add_apt_repository \
		"deb [signed-by=$gpg_file] http://apt.llvm.org/$dist/ llvm-toolchain-$dist-$version main
deb-src [signed-by=$gpg_file] http://apt.llvm.org/$dist/ llvm-toolchain-$dist-$version main" \
			'/etc/apt/sources.list.d/llvm.list'

		sudo apt-get -y update
		sudo apt-get -y install clang-17
		;;
	*)
		core.print_fatal "Pakage manager '$pkgmngr' not supported"
	esac
}

main "$@"
