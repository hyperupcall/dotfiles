# shellcheck shell=bash

main() {
	if util.confirm 'Install various editors?'; then
		install.editors
	fi
}

# Install Vim, Neovim, Nano, etc.
# BACKUP in case neovim stuff doesn't work or is too bugy
install.editors() {
	term.style_italic -dP 'Not Implemented'
}
