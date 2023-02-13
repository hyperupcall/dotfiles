# shellcheck shell=bash

main() {
	if util.confirm 'Install Browserpass?'; then
		# TODO: fix
		# browserpass-native
		{
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
		}

		# browserpass-extension
		core.print_warn "Not installing browserpass-extension, only the native client"
# 		{
# 			local version='3.7.2'

# 			core.print_info "Installing browserpass-native version '$version'"

# 			local url_firefox="https://addons.mozilla.org/firefox/downloads/file/3711209/browserpass-$version-fx.xpi"
# 			local url_chromium="https://github.com/browserpass/browserpass-extension/releases/download/$version/browserpass-github-$version.crx"

# 			local file_firefox='browserpass@maximbaz.com.xpi'
# 			local file_chromium='browserpass@maximbaz.com.crx'

# 			util.cd_temp

# 			util.req -o "$file_firefox" "$url_firefox" || util.die
# 			util.req -o "$file_chromium" "$url_chromium" || util.die

# 			util.run sudo mkdir -p "$install_dir/lib/browserpass-custom" || util.die

# 			# Firefox
# 			util.run sudo mv -fv "$file_firefox" "$install_dir/lib/browserpass-custom/$file_firefox" || util.die
# 			util.run sudo mkdir -p "/usr/lib/firefox/browser/extensions" || util.die
# 			util.run sudo ln -sfv "$install_dir/lib/browserpass-custom/$file_firefox" "/usr/lib/firefox/browser/extensions/$file_firefox" || util.die

# 			# Brave
# 			util.run sudo mv -fv "$file_chromium" "$install_dir/lib/browserpass-custom/$file_chromium" || util.die
# 			util.run sudo mkdir -p '/usr/share/chromium/extensions' || util.die

# 			printf '%s\n' "{
# 	\"external_crx\": \"$install_dir/lib/browserpass-custom/$file_chromium\",
# 	\"external_version\": \"$version\"
# }" | sudo tee >/dev/null "/usr/share/chromium/extensions/pjmbgaakjkbhpopmakjoedenlfdmcdgm.json"

# 			pushd >/dev/null
# 		}

	fi
}

main "$@"
