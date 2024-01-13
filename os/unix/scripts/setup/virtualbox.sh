#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	util.install_and_configure 'virtualbox' 'VirtualBox' "$@"
}

install.virtualbox() {
	local dist='jammy'
	local gpg_file="/etc/apt/keyrings/oracle-virtualbox-2016.asc"

	pkg.add_apt_key \
		'https://www.virtualbox.org/download/oracle_vbox_2016.asc' \
		"$gpg_file"

	pkg.add_apt_repository \
		"deb [arch=amd64 signed-by=$gpg_file] https://download.virtualbox.org/virtualbox/debian $dist contrib" \
		'/etc/apt/sources.list.d/virtualbox.list'
}

configure.virtualbox() {
	# TODO
	VBoxManage setproperty machinefolder '/storage/vault/rodinia/VirtualBox_Machines'
}

main "$@"
