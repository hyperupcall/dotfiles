#!/usr/bin/env bash
source ~/.dotfiles/data/setup.sh

declare -g g_name='Discord'

install.any() {
	curl -K "$CURL_CONFIG" -o './discord.tar.gz' 'https://discord.com/api/download?platform=linux&format=tar.gz'
	tar xf './discord.tar.gz'
	core.print_warn 'Do not know how to handle tarball on non-deb Linux'
}

install.debian() {
	curl -K "$CURL_CONFIG" -o './discord.deb' 'https://discord.com/api/download?platform=linux&format=deb'
	sudo dpkg -i ./discord.deb
	rm -f ./discord.deb
}

installed() {
	command -v discord &>/dev/null
}

util.if_file_sourced || _setup "$@"
