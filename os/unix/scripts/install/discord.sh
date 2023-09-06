#!/usr/bin/env bash

# Name:
# Install Discord

source "${0%/*}/../source.sh"

main() {
	if util.confirm "Install Discord?"; then
		install.discord "$@"
	fi
}

install.discord() {
	if util.is_cmd 'apt'; then (
		util.cd_temp
		util.req -o './discord.deb' 'https://discord.com/api/download?platform=linux&format=deb'
		sudo apt install ./discord.deb
	) else (
		util.cd_temp
		util.req -o './discord.tar.gz' 'https://discord.com/api/download?platform=linux&format=tar.gz'
		tar xf './discord.tar.gz'
	) fi
}

main "$@"
