#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

main() {
	helper.setup 'AppImageLauncher' "$@"
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

util.if_file_sourced || main "$@"
