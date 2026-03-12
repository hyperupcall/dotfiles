#!/usr/bin/env bash
source ~/.dotfiles/os-unix/data/setup.sh

declare -g g_name='Woof'

main() {
	util.install_by_setup "$@"
}

install.any() {
	basalt global add version-manager/woof
}

install.source() {
	local repo_dir="$_private_woof_dir"
	if [ ! -d "$repo_dir" ]; then
		core.print_error "Failed to find directory: $repo_dir"
	fi
	cd "$repo_dir"
	ln -sf "$PWD/pkg/bin/woof" ~/.local/bin/woof
}

installed() {
	command -v woof &>/dev/null
}

configure() {
	util.write_shellfile 'woof' \
		--bash 'eval "$(woof init --no-cd bash)"' \
		--zsh 'eval "$(woof init --no-cd zsh)"'
}

util.if_file_sourced || _setup "$@"
