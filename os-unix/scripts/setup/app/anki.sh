#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

main() {
	helper.setup 'Anki' "$@"
}

install.any() {
	local version=25.02
	curl -K "$CURL_CONFIG" -o ./anki.tar.zst "https://github.com/ankitects/anki/releases/download/$version/anki-$version-linux-qt6.tar.zst"
	tar xf ./anki.tar.zst
	cd anki-*/
	sudo ./install.sh
}

main "$@"
