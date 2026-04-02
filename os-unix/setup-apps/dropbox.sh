#!/usr/bin/env bash
source ~/.dotfiles/os-unix/data/setup.sh

declare -g g_name='Dropbox'

install.any() {
	core.print_info 'Downloading'
	curl -K "$CURL_CONFIG" -o ./dropbox.tar.gz 'https://www.dropbox.com/download?plat=lnx.x86_64'

	core.print_info 'Extracting'
	tar xzf ./dropbox.tar.gz

	core.print_info 'Copying'
	rm -rf ~/.home/Downloads/.dropbox-dist
	mv ./.dropbox-dist ~/.home/Downloads

	core.print_info 'Symlinking'
	ln -sf ~/.home/Downloads/.dropbox-dist/dropboxd ~/.dotfiles/.data/bin/dropboxd
}

installed() {
	[ -x ~/.dotfiles/.data/bin/dropboxd ]
}

util.if_file_sourced || _setup "$@"
