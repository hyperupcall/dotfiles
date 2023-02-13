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
	git switch master
	git pull --ff-only origin master

	local channel='nightly' # or stable
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

main "$@"
