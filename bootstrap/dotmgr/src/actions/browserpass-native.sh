# shellcheck shell=bash

# Name:
# Deploy Install BrowserPass Native
#
# Description:
# This mostly executes dotfox with the right arguments. The command is shown before it is ran. Before executing, however, it removes ~/.config/user-dirs.dirs

action() {
	local version='3.0.9'
	print.info "Installing version '$version'"

	local url="https://github.com/browserpass/browserpass-native/releases/download/$version/browserpass-linux64-$version.tar.gz"
	cd "$(mktemp -d)"


	curl -sSLo browserpass.tar.gz "$url"
	tar xf 'browserpass.tar.gz'
	cd "./browserpass-linux64-$version/"

	local system='linux64'
	make BIN="browserpass-$system" PREFIX=/usr/local configure
	sudo make BIN="browserpass-$system" PREFIX=/usr/local install
	# sudo make BIN="browserpass-$system" PREFIX=/usr/local hosts-brave # Doesn't work
	make BIN="browserpass-$system" PREFIX=/usr/local hosts-brave-user
	# sudo make BIN="browserpass-$system" PREFIX=/usr/local policies-brave
}
