# shellcheck shell=bash

# Name:
# Install Others
#
# Description:
# Installs miscellaneous packages. This includes:
# - Dropbox
# - Browserpass Brave Client (hard-coded to verison 3.0.9)
#

action() {
	# Dropbox
	{
		cd ~/.dots/.home/Downloads
		wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
		ln -sf ~/.dots/.home/Downloads/.dropbox-dist/dropboxd ~/.dots/.usr/bin/dropboxd
	}

	# Browserpass
	{
		local version='3.0.10'
		print.info "Installing version '$version'"

		local url="https://github.com/browserpass/browserpass-native/releases/download/$version/browserpass-linux64-$version.tar.gz"
		cd "$(mktemp -d)"


		curl -sSLo browserpass.tar.gz "$url"
		tar xf 'browserpass.tar.gz'
		cd "./browserpass-linux64-$version"

		local system='linux64'
		make BIN="browserpass-$system" PREFIX=/usr/local configure
		sudo make BIN="browserpass-$system" PREFIX=/usr/local install
		make BIN="browserpass-$system" PREFIX=/usr/local hosts-brave-user
	}
}
