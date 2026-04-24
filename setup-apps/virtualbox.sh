#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='VirtualBox'
declare -g g_sources_file='/etc/apt/sources.list.d/virtualbox.sources'

install.debian() {
	local dist=
	dist=$(lsb_release --codename --short)
	local gpg_file="/etc/apt/keyrings/oracle-virtualbox-2016.asc"

	pkg.add_apt_key \
		'https://www.virtualbox.org/download/oracle_vbox_2016.asc' \
		"$gpg_file"

	pkg.add_apt_repository \
		"$g_sources_file" "
			Types: deb
			URIs: https://download.virtualbox.org/virtualbox/debian
			Suites: $dist
			Components: contrib
			Architectures: $(dpkg --print-architecture)
			signed-by: $gpg_file"

	sudo apt-get update -y
	sudo apt-get install -y virtualbox virtualbox-guest-additions-iso
}

install.ubuntu() {
	local dist=
	dist=$(lsb_release --codename --short)
	local gpg_file="/etc/apt/keyrings/oracle-virtualbox-2016.asc"

	pkg.add_apt_key \
		'https://www.virtualbox.org/download/oracle_vbox_2016.asc' \
		"$gpg_file"

	pkg.add_apt_repository \
		"$g_sources_file" "
			Types: deb
			URIs: https://download.virtualbox.org/virtualbox/debian
			Suites: $dist
			Components: contrib
			Architectures: $(dpkg --print-architecture)
			signed-by: $gpg_file"

	sudo apt-get update -y
	sudo apt-get install -y virtualbox virtualbox-guest-additions-iso
}

installed() {
	[ -f "$g_sources_file" ] && command -v VirtualBox &>/dev/null
}

configure() {
	# VBoxManage setproperty machinefolder "$_private_virtualbox_dir"
	:
}

util.if_file_sourced || _setup "$@"
