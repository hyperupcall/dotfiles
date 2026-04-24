#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

main() {
	~/scripts/setup/fzf.sh
	util.install_by_setup_distro_package 'Zoxide' 'zoxide' 'zoxide' "$@"
}

configure() {
	util.write_shellfile 'zoxide' \
		--bash 'eval "$(zoxide init bash)"' \
		--zsh 'eval "$(zoxide init zsh)"' \
		--sh 'eval "$(zoxide init posix --hook prompt)"' \
		--fish 'zoxide init fish | source' \
		--elvish 'eval (zoxide init elvish | slurp)'
}

util.if_file_sourced || _main "$@"
