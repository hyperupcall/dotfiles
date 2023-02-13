# shellcheck shell=bash

# Name:
# VirtualBox Import
#
# Description:
# Registers all VirtualBox virtual machine. Optionally
# enables unregistering all virtual machines

main() {
	if util.is_cmd VBoxManage; then
		VBoxManage setproperty machinefolder '/storage/vault/rodinia/VirtualBox_Machines'
	else
		core.print_error "Must have command 'VBoxManage' installed"
		exit 1
	fi

	core.shopt_push -s nullglob

	local flag_unregister='no'

	for arg; do case $arg in
		--help|-h) printf '%s\n' "Usage: $0 [-h|--help] [--unregister] (add is default)" ;;
		--unregister) flag_unregister='yes'
	esac done

	if [ "$flag_unregister" = 'yes' ]; then
		while IFS= read -r line; do
			printf '%s\n' "Removing '${line}'"
			local uuid="${line%\}}"
			uuid=${uuid##*\{}
			VBoxManage unregistervm "$uuid"
		done < <(VBoxManage list vms)
		return
	fi

	local virtualbox_dir="/storage/vault/rodinia/VirtualBox_Machines"

	if [ ! -d "$virtualbox_dir" ]; then
		core.print_die "Could not find directory '$virtualbox_dir'"
	fi

	# Add all
	for group_dir in "$virtualbox_dir"/*/; do
		register "${group_dir%/}"

		for vm_dir in "$group_dir"*/; do
			register "${vm_dir%/}"
		done
	done

	core.shopt_pop
}

register() {
	local dir="$1"

	for file in "$dir"/*.vbox; do
		printf '%s\n' "Adding '$file'"
		VBoxManage registervm "$file"
	done
}

main "$@"
