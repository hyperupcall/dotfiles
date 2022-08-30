# shellcheck shell=bash

main() {
	if util.confirm 'Install Browserpass?'; then
		local version='3.7.2'
		core.print_info "Installing version '$version'"

		local url="https://github.com/browserpass/browserpass-native/releases/download/$version/browserpass-linux64-$version.tar.gz"
		cd "$(mktemp -d)"


		curl -sSLo browserpass.tar.gz "$url"
		tar xf 'browserpass.tar.gz'
		cd "./browserpass-linux64-$version"

		local system='linux64'
		make BIN="browserpass-$system" PREFIX=/usr/local configure
		sudo make BIN="browserpass-$system" PREFIX=/usr/local install
		make BIN="browserpass-$system" PREFIX=/usr/local hosts-brave-user

		# Symlink things
		for f in \
			"$XDG_CONFIG_HOME/"{BraveSoftware/Brave-Browser,sidekick,wavebox}"/NativeMessagingHosts/com.github.browserpass.native.json"
		do
			mkdir -p "${f%/*}"
			ln -sf /usr/local/lib/browserpass/hosts/chromium/com.github.browserpass.native.json "$f"
		done; unset -v f

		for f in \
			"$XDG_CONFIG_HOME/"{BraveSoftware/Brave-Browser,sidekick,wavebox}"/policies/managed/com.github.browserpass.native.json"
		do
			mkdir -p "${f%/*}"
			ln -s "/usr/local/lib/browserpass/policies/chromium/com.github.browserpass.native.json" "$f"
		done; unset -v f
	fi
}
