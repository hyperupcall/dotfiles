# shellcheck shell=bash

{
	if util.confirm 'Install Neovim latest?'; then
		install.neovim
	fi
}

install.neovim() {
	util.clone_in_dots 'https://github.com/neovim/neovim'
	declare dir="$REPLY"

	cd "$dir"
	git switch master
	git pull --ff-only origin master

	declare channel='nightly' # or stable
	git fetch origin "$channel"
	git branch -D 'build'
	git switch -c 'build' "tags/$channel"

	rm -rf './build'
	mkdir -p './build'

	make distclean
	make deps
	make CMAKE_BUILD_TYPE=RelWithDebInfo
	sudo make install
}
