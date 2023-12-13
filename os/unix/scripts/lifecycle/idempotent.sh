#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	~/.dotfiles/bake -f ~/.dotfiles/Bakefile.sh init

	"$VAR_DOTMGR_DIR/scripts/utility/create-dirs.sh"
	"$VAR_DOTMGR_DIR/scripts/utility/extract-aliases.sh"
	"$VAR_DOTMGR_DIR/scripts/utility/extract-shell-inits.sh"
	"$VAR_DOTMGR_DIR/scripts/utility/generate-dotconfig.sh"

	# TODO
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
