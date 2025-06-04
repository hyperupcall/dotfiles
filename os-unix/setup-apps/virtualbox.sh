#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

declare -g g_name='VirtualBox'

main() {
	util.install_by_setup "$@"
}

install.debian() {
	local dist='jammy'
	local gpg_file="/etc/apt/keyrings/oracle-virtualbox-2016.asc"

	pkg.add_apt_key \
		'https://www.virtualbox.org/download/oracle_vbox_2016.asc' \
		"$gpg_file"

	pkg.add_apt_repository \
		'/etc/apt/sources.list.d/virtualbox.sources' "
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
	local dist='noble'
	local gpg_file="/etc/apt/keyrings/oracle-virtualbox-2016.asc"

	pkg.add_apt_key \
		'https://www.virtualbox.org/download/oracle_vbox_2016.asc' \
		"$gpg_file"

	pkg.add_apt_repository \
		'/etc/apt/sources.list.d/virtualbox.sources' "
			Types: deb
			URIs: https://download.virtualbox.org/virtualbox/debian
			Suites: $dist
			Components: contrib
			Architectures: $(dpkg --print-architecture)
			signed-by: $gpg_file"

	# sudo apt-get update -y
	# sudo apt-get install -y virtualbox virtualbox-guest-additions-iso
}

installed() {
	command -v VirtualBox &>/dev/null
}

configure() {
	VBoxManage setproperty machinefolder '/storage/bigfiles/VirtualBox_Machines'
}

util.if_file_sourced || _setup "$@"
