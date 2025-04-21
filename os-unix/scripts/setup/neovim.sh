#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

main() {
	helper.setup 'Neovim' "$@"
}

install.any() {
	helper.setup --no-confirm --fn-prefix=install_gettext.debian
	install_gettext.debian() {
		sudo apt-get -y install gettext
	}
	install_gettext.fedora() {
		sudo dnf install -y gettext
	}
	install_gettext.opensuse() {
		sudo zypper -n install gettext
	}
	install_gettext.arch() {
		sudo pacman -Syu --noconfirm gettext
	}

	local dir="$HOME/.dotfiles/.data/repos/neovim"
	util.clone "$dir" 'https://github.com/neovim/neovim'

	cd "$dir"
	git switch master
	git pull --ff-only me master

	# Use "nightly" or "stable".
	local tag='stable'
	git fetch --tags --force me "$tag"
	if git show-ref --quiet 'refs/heads/build'; then
		git branch -D 'build'
	fi
	git switch -c 'build' "tags/$tag"

	rm -rf './build'
	mkdir -p './build'

	make distclean
	make deps
	make CMAKE_BUILD_TYPE=Release
	sudo make install
}

install.arch() {
	yay -S --noconfirm neovim
}

installed() {
	neovim_version_check() {
		local -a nvim_version_arr
		nvim_version=$(nvim --version)
		nvim_version=${nvim_version%%$'\n'*}
		nvim_version=${nvim_version#NVIM v}
		nvim_version=${nvim_version%%-*}
		IFS='.' read -ra nvim_version_arr <<< "$nvim_version"
		(( nvim_version_arr[0] >= 1 || (nvim_version_arr[0] == 0 && nvim_version_arr[1] >= 10) ))
	}

	command -v nvim &>/dev/null && neovim_version_check
}

util.if_file_sourced || main "$@"
