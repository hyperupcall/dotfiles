#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	if util.confirm 'Install Dropbox?'; then
		install.dropbox
	fi
}

install.dropbox() {
	util.cd_temp

	core.print_info 'Downloading'
	util.req -o ./dropbox.tar.gz 'https://www.dropbox.com/download?plat=lnx.x86_64'

	core.print_info 'Extracting'
	tar xzf ./dropbox.tar.gz

	core.print_info 'Copying'
	rm -rf ~/.dotfiles/.home/Downloads/.dropbox-dist
	mv ./.dropbox-dist ~/.dotfiles/.home/Downloads

	core.print_info 'Symlinking'
	ln -sf ~/.dotfiles/.home/Downloads/.dropbox-dist/dropboxd ~/.dotfiles/.data/bin/dropboxd
}

main "$@"
