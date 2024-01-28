#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	if util.confirm 'Install pass?'; then
		helper.run_for_distro "$@"
	fi

	if util.confirm 'Clone password repository?'; then
		local dir="${PASSWORD_STORE_DIR:-$HOME/.password-store}"

		if [ -d "$dir" ]; then
			if [ -d "$dir/.git" ]; then
				core.print_info "Secrets repository already cloned"
			else
				core.print_error "Non-git directory already exists in place of secrets dir. Please remove manually"
				exit 1
			fi
		else
			git clone 'git@github.com:hyperupcall/secrets' "$dir"
		fi
	fi
}

install.debian() {
	sudo apt-get -y update
	sudo apt-get -y install pass
}

install.ubuntu() {
	install.debian "$@"
}

install.fedora() {
	sudo dnf -y update
	sudo dnf -y install pass
}

install.opensuse() {
	sudo zypper refresh
	sudo zypper -y install pass
}

install.pacman() {
	yay -Syu pass
}

main "$@"
