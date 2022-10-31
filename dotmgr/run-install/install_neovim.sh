# shellcheck shell=bash

main() {
	if util.confirm 'Install Neovim latest?'; then
		install.neovim
	fi
}

install.neovim() {
	term.style_italic -dP 'Not Implemented'
	exit 1

	util.get_latest_github_tag 'neovim/neovim'
	local latest_tag="$REPLY"

	local url="https://github.com/neovim/neovim/releases/download/$latest_tag/nvim-linux64.tar.gz"
}
