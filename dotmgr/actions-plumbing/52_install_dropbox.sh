# shellcheck shell=bash

main() {
	if util.confirm 'Install Dropbox stuff?'; then
		util.cd_temp

		core.print_info 'Downloading'
		util.req -o ./dropbox.tar.gz "https://www.dropbox.com/download?plat=lnx.x86_64"

		core.print_info 'Extracting'
		tar xzf ./dropbox.tar.gz

		core.print_info 'Copying'
		rm -rf ~/.dots/.home/Downloads/.dropbox-dist
		mv ./.dropbox-dist ~/.dots/.home/Downloads

		core.print_info 'Symlinking'
		ln -sf ~/.dots/.home/Downloads/.dropbox-dist/dropboxd ~/.dots/.usr/bin/dropboxd

		popd >/dev/null
	fi
}
