# shellcheck shell=bash

main() {
	if util.confirm 'Install Neovim?'; then
		install.neovim
	fi
}

install.neovim() {
	term.style_italic -dP 'Not Implemented'
}