# shellcheck shell=bash

# Name:
# Idempotent Scripts
#
# Description:
# Idempotently configures the desktop. This includes:
# - Ensures mount to /storage/ur
# - Strip ~/.bashrc, etc. dotfiles from random appendage
# - Symlinks ~/.ssh, etc. software not mananged by dotfox
# - Symlinks directories to ~/.dotfiles/.home

{
	(
		cd ~/.dotfiles || exit
		./bake init
	)

	util.run_script 'scripts-misc' '10_dirs.sh'

	util.run_script 'scripts-misc' '12_dot_funcalias_extractor.sh'
	util.run_script 'scripts-misc' '13_dot_shell_generator.sh'
	# TODO: if wrong directory is called, infinite loop (util.run_script 'run-misc' 'actions' '12_sync_dotfiles.sh')
	util.run_script 'scripts' '12_sync_dotfiles.sh'


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
