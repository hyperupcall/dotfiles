#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	if util.confirm 'Install Dropbox stuff?'; then
		util.cd_temp

		core.print_info 'Downloading'
		util.req --http1.1 -o ./dropbox.tar.gz "https://www.dropbox.com/download?plat=lnx.x86_64" || util.die

		core.print_info 'Extracting'
		tar xzf ./dropbox.tar.gz || util.die

		core.print_info 'Copying'
		rm -rf ~/.dotfiles/.home/Downloads/.dropbox-dist || util.die
		mv ./.dropbox-dist ~/.dotfiles/.home/Downloads || util.die

		core.print_info 'Symlinking'
		ln -sf ~/.dotfiles/.home/Downloads/.dropbox-dist/dropboxd ~/.dotfiles/.data/bin/dropboxd || util.die
	fi
}

main "$@"
