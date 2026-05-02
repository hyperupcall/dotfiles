#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='Basalt'

install.any() {
	curl -K "$CURL_CONFIG" https://raw.githubusercontent.com/bash-bastion/basalt/main/scripts/install.sh | sh

	ln -fs ~/.local/share/basalt/source/pkg/bin/basalt ~/.local/bin/basalt >/dev/null
	ln -fs ~/.local/share/basalt/source/pkg/bin/basalt-package-init ~/.local/bin/basalt-package-init >/dev/null

	eval "$(basalt global init bash)"
	basalt global add \
		hyperupcall/autoenv \
		hyperupcall/bake

	basalt global add \
		hyperupcall-projects/kcomplete-alias \
		hyperupcall-projects/kbash-preexec \
		hyperupcall-projects/kshdoc
}

install.installed() {
	command -v basalt &>/dev/null && command -v shdoc &>/dev/null
}

install.configure() {
	util.write_shellfile 'basalt' \
		--bash 'eval "$(basalt global init bash)"' \
		--zsh 'eval "$(basalt global init zsh)"' \
		--sh 'eval "$(basalt global init sh)"'
}

util.if_file_sourced || _setup "$@"
