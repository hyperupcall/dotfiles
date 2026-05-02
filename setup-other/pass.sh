#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='pass'
declare -g g_password_store_dir="${PASSWORD_STORE_DIR:-"$HOME/.password-store"}"

install.debian() {
	sudo apt-get -y update
	sudo apt-get -y install pass

	prompt_extra_installs
}

install.ubuntu() {
	install.debian "$@"
}

install.fedora() {
	sudo dnf -y update
	sudo dnf -y install pass

	prompt_extra_installs
}

install.opensuse() {
	sudo zypper -n refresh
	sudo zypper -n install password-store

	prompt_extra_installs
}

install.arch() {
	yay -Syu --noconfirm pass

	prompt_extra_installs
}

install.installed() {
	command -v pass &>/dev/null && [ -d "$g_password_store_dir" ]
}

prompt_extra_installs() {
	if util.confirm 'Clone password repository?'; then
		if [ -d "$g_password_store_dir" ]; then
			if [ -d "$g_password_store_dir" ]; then
				core.print_info "Secrets repository already cloned"
			else
				core.print_die "Non-git directory already exists in place of secrets dir. Please remove manually"
			fi
		else
			util.clone "$g_password_store_dir" "$_private_password_remote"
		fi
	fi

	if util.confirm 'Install native extension?'; then
		install_native_extension
	fi
}

install_native_extension() {
	util.get_latest_github_release 'browserpass/browserpass-native'
	local version="$REPLY"
	local system='linux64'
	local install_dir='/usr/local'
	local app_id='com.github.browserpass.native.json'

	core.print_info "Installing browserpass-native version $version"

	local url="https://github.com/browserpass/browserpass-native/releases/download/$version/browserpass-$system-${version#v}.tar.gz"
	curl -K "$CURL_CONFIG" -o ./browserpass.tar.gz "$url"
	tar xf ./browserpass.tar.gz
	cd "./browserpass-linux64-${version#v}"

	make BIN="browserpass-$system" PREFIX="$install_dir" configure
	sudo make BIN="browserpass-$system" PREFIX="$install_dir" install

	# Symlink the messaging host definitions.
	local dir=
	for dir in \
		"$XDG_CONFIG_HOME"/{BraveSoftware/Brave-Browser{,-Beta,-Nightly},vivaldi{,-snapshot},microsoft-edge{,-beta,-dev},google-chrome{,-beta,-unstable},opera{,-beta,-developer},sidekick,wavebox}/; do
		if [ -d "$dir" ]; then
			mkdir -p "$dir/NativeMessagingHosts"
			ln -sfv "$install_dir/lib/browserpass/hosts/chromium/$app_id" "$dir/NativeMessagingHosts/$app_id"

			mkdir -p "$dir/policies/managed"
			ln -sfv "$install_dir/lib/browserpass/policies/chromium/$app_id" "$dir/policies/managed/$app_id"
		fi
	done

	# Firefox
	mkdir -p "${HOME}/.mozilla/native-messaging-hosts"
	ln -sfv "$install_dir/lib/browserpass/hosts/firefox/$app_id" "${HOME}/.mozilla/native-messaging-hosts/$app_id"

	core.print_warn "Not installing browserpass-extension, only the native client"
}

util.if_file_sourced || _setup "$@"
