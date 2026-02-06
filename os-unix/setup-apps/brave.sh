#!/usr/bin/env bash
source ~/.dotfiles/os-unix/data/setup.sh

declare -g g_name='Brave'

main() {
	util.install_by_setup "$@"
}

install.debian() {
	local gpg_file_release="/etc/apt/keyrings/brave-browser-release.gpg"
	local gpg_file_beta="/etc/apt/keyrings/brave-browser-beta.gpg"
	local gpg_file_nightly="/etc/apt/keyrings/brave-browser-nightly.gpg"

	pkg.add_apt_key \
		'https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg' \
		"$gpg_file_release"
	pkg.add_apt_key \
		'https://brave-browser-apt-beta.s3.brave.com/brave-browser-beta-archive-keyring.gpg' \
		"$gpg_file_beta"
	pkg.add_apt_key \
		'https://brave-browser-apt-nightly.s3.brave.com/brave-browser-nightly-archive-keyring.gpg' \
		"$gpg_file_nightly"

	pkg.add_apt_repository \
		'/etc/apt/sources.list.d/brave-browser-release.sources' "
			Types: deb
			URIs: https://brave-browser-apt-release.s3.brave.com/
			Suites: stable
			Components: main
			Architectures: $(dpkg --print-architecture)
			signed-by: $gpg_file_release"

	pkg.add_apt_repository \
		'/etc/apt/sources.list.d/brave-browser-beta.sources' "
			Types: deb
			URIs: https://brave-browser-apt-beta.s3.brave.com/
			Suites: stable
			Components: main
			Architectures: $(dpkg --print-architecture)
			signed-by: $gpg_file_beta"

	pkg.add_apt_repository \
		'/etc/apt/sources.list.d/brave-browser-nightly.sources' "
			Types: deb
			URIs: https://brave-browser-apt-nightly.s3.brave.com/
			Suites: stable
			Components: main
			Architectures: $(dpkg --print-architecture)
			signed-by: $gpg_file_nightly"

	sudo apt-get -y update
	sudo apt-get -y install brave-browser brave-browser-beta
}

install.ubuntu() {
	install.debian "$@"
}

install.fedora() {
	pkg.add_dnf_repository 'https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo'
	pkg.add_dnf_repository 'https://brave-browser-rpm-beta.s3.brave.com/brave-browser.repo'

	sudo dnf -y update
	sudo dnf -y install brave-browser brave-browser-beta
}

install.opensuse() {
	sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
	sudo rpm --import https://brave-browser-rpm-beta.s3.brave.com/brave-core-nightly.asc

	sudo zypper -n addrepo https://brave-browser-rpm-release.s3.brave.com/x86_64/ brave-browser
	sudo zypper addrepo https://brave-browser-rpm-beta.s3.brave.com/x86_64/ brave-browser-beta

	sudo zypper refresh
	sudo zypper -n install brave-browser brave-browser-beta
}

install.manjaro() {
	yay -S brave-browser brave-browser-beta
}

install.arch() {
	yay -S brave-bin brave-beta-bin
}

installed() {
	command -v brave-browser &>/dev/null && command -v brave-browser-beta &>/dev/null
}

util.if_file_sourced || _setup "$@"
