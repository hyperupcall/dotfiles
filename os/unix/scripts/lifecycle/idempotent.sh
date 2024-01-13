#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	~/.dotfiles/bake -f ~/.dotfiles/Bakefile.sh init

	"$HOME/.dotfiles/os/unix/scripts/utility/create-dirs.sh"
	"$HOME/.dotfiles/os/unix/scripts/utility/generate-aliases.sh"
	"$HOME/.dotfiles/os/unix/scripts/utility/generate-dotgen.sh"
	"$HOME/.dotfiles/os/unix/scripts/utility/generate-dotconfig.sh"
}

main "$@"
