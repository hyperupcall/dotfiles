#!/usr/bin/env bash
source ~/.dotfiles/os-unix/data/setup.sh

declare -g g_name='AppImageLauncher'

main() {
	util.install_by_setup "$@"
}

install.arch() {
	yay -S appimagelauncher
}

install.manjaro() {
	: # Installed by default.
}

install.debian() {
	get_appimagelauncher_release_file 'deb'

	curl -K "$CURL_CONFIG" -o 'appimagelauncher.deb' "$REPLY"
	sudo dpkg -i './appimagelauncher.deb'
	rm -f './appimagelauncher.deb'
}

install.ubuntu() {
	install.debian "$@"
}

install.fedora() {
	get_appimagelauncher_release_file 'rpm'

	curl -K "$CURL_CONFIG" -o 'appimagelauncher.rpm' "$REPLY"
	rm -f './appimagelauncher.rpm'
}

install.opensuse() {
	install.fedora "$@"
}

installed() {
	command -v appimagelauncherd &>/dev/null
}

get_appimagelauncher_release_file() {
	local ext="$1"

	util.get_latest_github_tag 'TheAssassin/AppImageLauncher'
	local latest_tag=$REPLY

	local token=
	token="$(<~/.dotfiles/.data/github_token)"

	local filenames=
	filenames=$(curl -K "$CURL_CONFIG" \
		-H "Accept: application/vnd.github+json" \
		-H "Authorization: Bearer $token" \
		-H "X-GitHub-Api-Version: 2022-11-28" \
		"https://api.github.com/repos/TheAssassin/AppImageLauncher/releases/tags/$latest_tag" \
			| jq -r '.assets[] | .name'
	)

	REPLY=
	local filename=
	while IFS=$'\n' read -r filename; do
		if [[ $filename == *_@(x86_64|amd64)."$ext" ]]; then
			REPLY="https://github.com/TheAssassin/AppImageLauncher/releases/download/$latest_tag/$filename"
		fi
	done <<< "$filenames"

	if [ -z "$REPLY" ]; then
		core.print_die "Unable to find release file"
	fi
}

# TODO
build_from_source() {
	sudo apt-get install -y make cmake libglib2.0-dev libcairo2-dev librsvg2-dev libfuse-dev libarchive-dev libxpm-dev libcurl4-openssl-dev libboost-all-dev qtbase5-dev qtdeclarative5-dev qttools5-dev-tools patchelf libc6-dev libc6-dev gcc-multilib g++-multilib

	local dir="$HOME/.dotfiles/.data/repos/AppImageLauncher"
	util.clone "$dir" git@github.com:TheAssassin/AppImageLauncher
	cd "$dir"

	git submodule update --init --recursive
	mkdir build
	cd build

	cmake .. -DCMAKE_INSTALL_PREFIX="$PREFIX" -DUSE_SYSTEM_BOOST=true
	make libappimage libappimageupdate libappimageupdate-qt
	cmake .
	make
}

util.if_file_sourced || _setup "$@"
