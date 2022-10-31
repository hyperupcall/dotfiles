# shellcheck shell=bash

main() {
	if util.confirm 'Install Neovim latest?'; then
		install.neovim
	fi
}

install.neovim() {
	# util.get_latest_github_tag 'neovim/neovim'
	# local latest_tag="$REPLY"

	# local url="https://github.com/neovim/neovim/releases/download/$latest_tag/nvim-linux64.tar.gz"

	util.clone_in_dots 'https://github.com/neovim/neovim'
	local dir="$REPLY"

	cd "$dir"
	git pull
	git checkout stable
	if ! git rev-parse --verify --quiet stable >/dev/null; then
		git switch -c stable
	fi

	make CMAKE_BUILD_TYPE=RelWithDebInfo
	sudo make install
}
