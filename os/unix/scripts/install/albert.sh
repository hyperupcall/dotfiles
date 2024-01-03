#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	if util.confirm 'Install Albert?'; then
		install.albert
	fi
}

install.albert() {
	# Build from source since pre-build binaries can be very out of date
	util.get_package_manager
	local pkgmngr="$REPLY"

	if util.is_cmd 'apt'; then
		sudo apt-get install -y libarchive-dev
	fi

	util.clone_in_dotfiles 'https://github.com/albertlauncher/albert' --recursive
	local dir="$REPLY"
	cd "$dir"

	if [ ! -d lib/pybind11 ]; then
		git submodule add https://github.com/pybind/pybind11 lib/pybind11
	fi
	(
		cd lib/pybind11
		git switch --detach v2.11.1
		if [ ! -d .venv ]; then
			python3 -m venv .venv
		fi
		source .venv/bin/activate
		pip install -r tests/requirements.txt
		cmake -S . -B build -DDOWNLOAD_CATCH=ON -DDOWNLOAD_EIGEN=ON
		cmake --build build -j4
		sudo cmake --install build
	)

	if [ ! -d lib/Qalculate ]; then
		git submodule add https://github.com/Qalculate/libqalculate lib/Qalculate
	fi
	(
		cd lib/Qalculate
		git switch --detach v4.9.0
		./autogen.sh
		./configure --prefix=/usr/local
		make
		sudo make install
	)

	mise install cmake
	PATH="$XDG_DATA_HOME/mise/shims:$PATH"
	cmake -B build -S . -DCMAKE_INSTALL_PREFIX=/usr/local -DCMAKE_BUILD_TYPE=Debug
	cmake --build build
	sudo cmake --install build

	# TODO
	# case $pkgmngr in
	# apt)
	# 	local version='22.04'
	# 	source /etc/os-release
	# 	if [ "$ID" = 'zorin' ]; then
	# 		if [ "$VERSION_ID" = 16 ]; then
	# 			version='20.04'
	# 		elif [ "$VERSION_ID" = 15 ]; then
	# 			version='20.04'
	# 		fi
	# 	fi
	# 	local gpg_file="/etc/apt/keyrings/albert"


	# 	pkg.add_apt_key \
	# 		"https://download.opensuse.org/repositories/home:manuelschneid3r/xUbuntu_$version/Release.key" \
	# 		"$gpg_file"

	# 	pkg.add_apt_repository \
	# 		"deb [signed-by=$gpg_file] http://download.opensuse.org/repositories/home:/manuelschneid3r/xUbuntu_$version/ /" \
	# 		'/etc/apt/sources.list.d/albert.list'

	# 	sudo apt update
	# 	sudo apt-get install -y albert
	# 	;;
	# *)
	# 	core.print_fatal "Pakage manager '$pkgmngr' not supported"
	# 	;;
	# esac
}

main "$@"
