# shellcheck shell=bash

# Name:
# Idempotent Scripts
#
# Description:
# Idempotently configures the desktop. This includes:
# - Ensures mount to /storage/ur
# - Strip ~/.bashrc, etc. dotfiles from random appendage
# - Symlinks ~/.ssh, etc. software not mananged by dotfox
# - Symlinks directories to ~/.dots/.home

main() {
	dotmgr.get_profile
	local profile="$REPLY"

	dotmgr.call '10_dirs.sh'
	dotmgr.call '11_dconf.sh'

	dotmgr.call '12_dot_funcalias_extractor.sh'
	dotmgr.call '13_dot_shell_generator.sh'
	dotmgr.call '14_dotfox_deploy.sh' # TODO

	# TODO: install http-server nodejs
	if [ "$profile" = 'desktop' ]; then
		if util.is_cmd VBoxManage; then
			VBoxManage setproperty machinefolder '/storage/vault/rodinia/VirtualBox_Machines'
		fi
	fi

	if ! command -v file_server &>/dev/null; then
		if command -v deno &>/dev/null; then
			deno install --allow-net --allow-read https://deno.land/std@0.145.0/http/file_server.ts
		else
			core.print_warn "Deno not installed. Skipping installation of 'file_server'"
		fi
	fi

	if util.confirm "Update Packer?"; then
		nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
	fi
}
