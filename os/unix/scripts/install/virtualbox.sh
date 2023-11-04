#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	local dist='jammy'
	local gpg_file="/etc/apt/keyrings/oracle-virtualbox-2016.asc"

	pkg.add_apt_key \
		'https://www.virtualbox.org/download/oracle_vbox_2016.asc' \
		"$gpg_file"

	pkg.add_apt_repository \
		"deb [arch=amd64 signed-by=$gpg_file] https://download.virtualbox.org/virtualbox/debian $dist contrib" \
		'/etc/apt/sources.list.d/virtualbox.list'
}


main "$@"
