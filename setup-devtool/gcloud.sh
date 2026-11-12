#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='Google Cloud CLI'
declare -g g_install_dir="${XDG_DATA_HOME:-$HOME/.local/share}/google-cloud-sdk"
declare -g g_sources_file='/etc/apt/sources.list.d/google-cloud-cli.sources'

install.any() {
	curl -K "$CURL_CONFIG" https://sdk.cloud.google.com | bash -s -- \
		--disable-prompts \
		--install-dir="$g_install_dir" \
		--path-update=false
}

install.debian() {
	local gpg_file='/etc/apt/keyrings/google-cloud-cli.asc'

	pkg.add_apt_key \
		'https://packages.cloud.google.com/apt/doc/apt-key.gpg' \
		"$gpg_file"

	pkg.add_apt_repository \
		"$g_sources_file" "
			Types: deb
			URIs: https://packages.cloud.google.com/apt
			Suites: cloud-sdk
			Components: main
			Architectures: $(dpkg --print-architecture)
			signed-by: $gpg_file"

	sudo apt-get -y update
	sudo apt-get -y install google-cloud-cli
}

install.ubuntu() {
	install.debian "$@"
}

install.installed() {
	command -v gcloud &>/dev/null || [ -x "$g_install_dir/bin/gcloud" ]
}

install.configure() {
	util.write_shellfile 'gcloud' \
		--sh 'export PATH="${XDG_DATA_HOME:-$HOME/.local/share}/google-cloud-sdk/bin:$PATH"' \
		--bash 'export PATH="${XDG_DATA_HOME:-$HOME/.local/share}/google-cloud-sdk/bin:$PATH"' \
		--zsh 'export PATH="${XDG_DATA_HOME:-$HOME/.local/share}/google-cloud-sdk/bin:$PATH"' \
		--fish 'fish_add_path "${XDG_DATA_HOME:-$HOME/.local/share}/google-cloud-sdk/bin"'
}

util.if_file_sourced || _setup "$@"
