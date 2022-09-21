# shellcheck shell=bash

main() {
	if util.confirm 'Install Browserpass?'; then
		local version='3.0.10'
		local system='linux64'
		local install_dir='/usr/local'

		core.print_info "Installing version '$version'"

		local url="https://github.com/browserpass/browserpass-native/releases/download/$version/browserpass-$system-$version.tar.gz"

		util.cd_temp

		util.req -o ./browserpass.tar.gz "$url" || util.die
		tar xf ./browserpass.tar.gz || util.die
		cd "./browserpass-linux64-$version" || util.die

		util.run make BIN="browserpass-$system" PREFIX="$install_dir" configure || util.die
		util.run sudo make BIN="browserpass-$system" PREFIX="$install_dir" install || util.die

		local browsers=

		# Symlink messaging host definition
		for f in \
			"$XDG_CONFIG_HOME"/{BraveSoftware/Brave-Browser{,-Beta,-Nightly},microsoft-edge,google-chrome{,-beta,-unstable},opera,sidekick,wavebox}/"NativeMessagingHosts/com.github.browserpass.native.json"
		do
			mkdir -p "${f%/*}"
			ln -vsf "$install_dir/lib/browserpass/hosts/chromium/com.github.browserpass.native.json" "$f"
		done

		# Symlink policies
		for f in \
			"$XDG_CONFIG_HOME"/{BraveSoftware/Brave-Browser{,-Beta,-Nightly},microsoft-edge,google-chrome{,-beta,-unstable},opera,sidekick,wavebox}/"policies/managed/com.github.browserpass.native.json"
		do
			mkdir -p "${f%/*}"
			ln -vsf "$install_dir/lib/browserpass/policies/chromium/com.github.browserpass.native.json" "$f"
		done
	fi
}
