#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	util.clone_in_dots 'https://github.com/marvinkreis/rofi-json-menu'
	make
	sudo make install
}

main "$@"
