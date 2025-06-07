#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

declare -g g_name='AppImageLauncher'
declare -g g_disable='true'

main() {
	sudo apt-get install -y make cmake libglib2.0-dev libcairo2-dev librsvg2-dev libfuse-dev libarchive-dev libxpm-dev libcurl4-openssl-dev libboost-all-dev qtbase5-dev qtdeclarative5-dev qttools5-dev-tools patchelf libc6-dev libc6-dev gcc-multilib g++-multilib

	local dir="$HOME/.dotfiles/.data/repos/AppImageLauncher"
	util.clone "$dir" git@github.com:TheAssassin/AppImageLauncher
	cd "$dir"

	git submodule update --init --recursive
	mkdir build
	cd build

	cmake .. -DCMAKE_INSTALL_PREFIX="$PREFIX" -DUSE_SYSTEM_BOOST=true
	make libappimage libappimageupdate libappimageupdate-qt
	cmake .
	make
}

install.arch() {
	yay -S appimagelauncher
}

install.manjaro() {
	: # Installed by default.
}

install.debian() {
	curl -K "$CURL_CONFIG" -o 'appimagelauncher.deb' 'https://github.com/TheAssassin/AppImageLauncher/releases/download/v2.2.0/appimagelauncher_2.2.0-travis995.0f91801.bionic_amd64.deb'
	sudo dpkg -i './appimagelauncher.deb'
	rm -f './appimagelauncher.deb'
}

install.ubuntu() {
	install.debian "$@"
}

install.fedora() {
	curl -K "$CURL_CONFIG" -o 'appimagelauncher.rpm' 'https://github.com/TheAssassin/AppImageLauncher/releases/download/v2.2.0/appimagelauncher-2.2.0-travis995.0f91801.x86_64.rpm'
	sudo rpm -i 'appimagelauncher.rpm'
	rm -f './appimagelauncher.rpm'
}

install.opensuse() {
	install.fedora "$@"
}

util.if_file_sourced || _setup "$@"
