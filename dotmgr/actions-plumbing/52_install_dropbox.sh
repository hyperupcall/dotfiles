# shellcheck shell=bash

main() {
	if util.confirm 'Install Dropbox stuff?'; then
		cd ~/.dots/.home/Downloads
		wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
		ln -sf ~/.dots/.home/Downloads/.dropbox-dist/dropboxd ~/.dots/.usr/bin/dropboxd
	fi
}
