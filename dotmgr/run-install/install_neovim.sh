# shellcheck shell=bash

main() {
	if util.confirm 'Install Neovim latest?'; then
		install.neovim
	fi
}

install.neovim() {
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
