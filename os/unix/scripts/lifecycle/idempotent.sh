#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	~/.dotfiles/bake -f ~/.dotfiles/Bakefile.sh init

	"$VAR_DOTMGR_DIR/scripts/utility/create-dirs.sh"
	"$VAR_DOTMGR_DIR/scripts/utility/generate-aliases.sh"
	"$VAR_DOTMGR_DIR/scripts/utility/generate-dotgen.sh"
	"$VAR_DOTMGR_DIR/scripts/utility/generate-dotconfig.sh"
}

main "$@"
