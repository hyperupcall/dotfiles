#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	if util.confirm 'Setup VirtualBox?'; then
		setup.virtualbox
	fi
}

setup.virtualbox() {
	VBoxManage setproperty machinefolder '/storage/vault/rodinia/VirtualBox_Machines'
}

main "$@"
