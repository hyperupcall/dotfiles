#!/usr/bin/env bash

# Name:
# Idempotent Scripts
#
# Description:
# Idempotently configures the desktop. This includes:
# - Ensures mount to /storage/ur
# - Strip ~/.bashrc, etc. dotfiles from random appendage
# - Symlinks ~/.ssh, etc. software not mananged by dotfox
# - Symlinks directories to ~/.dotfiles/.home

source "${0%/*}/../source.sh"

main() {
	~/.dotfiles/bake init

	util.run_script 'scripts-misc' '10_dirs.sh'

	util.run_script 'scripts-misc' '12_dot_funcalias_extractor.sh'
	util.run_script 'scripts-misc' '13_dot_shell_generator.sh'


	# if [ "$profile" = 'desktop' ]; then
	# 	if util.is_cmd VBoxManage; then
	# 		VBoxManage setproperty machinefolder '/storage/vault/rodinia/VirtualBox_Machines'
	# 	fi
	# fi

	# if ! command -v file_server &>/dev/null; then
	# 	if command -v deno &>/dev/null; then
	# 		deno install --allow-net --allow-read https://deno.land/std@0.145.0/http/file_server.ts
	# 	else
	# 		core.print_warn "Deno not installed. Skipping installation of 'file_server'"
	# 	fi
	# fi

	# if util.confirm "Update Packer?"; then
	# 	nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
	# fi
}

main "$@"
