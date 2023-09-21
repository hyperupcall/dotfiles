#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	if util.confirm 'Install Browserpass?'; then
		install.browserpass
	fi
}

install.browserpass() {
	# browserpass-native
	local version='3.0.10'
	local system='linux64'
	local install_dir='/usr/local'
	local app_id='com.github.browserpass.native.json'

	core.print_info "Installing browserpass-native version '$version'"

	local url="https://github.com/browserpass/browserpass-native/releases/download/$version/browserpass-$system-$version.tar.gz"

	util.cd_temp

	util.req -o ./browserpass.tar.gz "$url" || util.die
	tar xf ./browserpass.tar.gz || util.die
	cd "./browserpass-linux64-$version" || util.die

	util.run make BIN="browserpass-$system" PREFIX="$install_dir" configure || util.die
	util.run sudo make BIN="browserpass-$system" PREFIX="$install_dir" install || util.die

	# TODO: don't create a million directories
	# Symlink messaging host definition
	for f in \
		"$XDG_CONFIG_HOME"/{BraveSoftware/Brave-Browser{,-Beta,-Nightly},vivaldi{,-snapshot},microsoft-edge{,-beta,-dev},google-chrome{,-beta,-unstable},opera{,-beta,-developer},sidekick,wavebox}/"NativeMessagingHosts/$app_id"
	do
		mkdir -p "${f%/*}"
		ln -sfv  "$install_dir/lib/browserpass/hosts/chromium/$app_id" "$f"
	done

	# Symlink policies
	for f in \
		"$XDG_CONFIG_HOME"/{BraveSoftware/Brave-Browser{,-Beta,-Nightly},vivaldi{,-snapshot},microsoft-edge{,-beta,-dev},google-chrome{,-beta,-unstable},opera{,-beta,-developer},sidekick,wavebox}/"policies/managed/$app_id"
	do
		mkdir -p "${f%/*}"
		ln -sfv "$install_dir/lib/browserpass/policies/chromium/$app_id" "$f"
	done

	# Firefox
	mkdir -p "${HOME}/.mozilla/native-messaging-hosts"
	ln -sfv "$install_dir/lib/browserpass/hosts/firefox/$app_id" "${HOME}/.mozilla/native-messaging-hosts/$app_id"

	# browserpass-extension
	core.print_warn "Not installing browserpass-extension, only the native client"
}

main "$@"
