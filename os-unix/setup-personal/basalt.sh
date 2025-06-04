#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

declare -g g_name='Basalt'

main() {
	curl -K "$CURL_CONFIG" https://raw.githubusercontent.com/bash-bastion/basalt/main/scripts/install.sh | sh

	ln -fs ~/.local/share/basalt/source/pkg/bin/basalt ~/.local/bin/basalt >/dev/null
	ln -fs ~/.local/share/basalt/source/pkg/bin/basalt-package-init ~/.local/bin/basalt-package-init >/dev/null

	basalt global add \
		hyperupcall/autoenv \
		hyperupcall/bake

	basalt global add \
		cykerway/complete-alias \
		rcaloras/bash-preexec \
		reconquest/shdoc
}

installed() {
	command -v basalt &>/dev/null
}

configure() {
	util.write_shellfile 'direnv' \
		--bash 'eval "$(basalt global init bash)"' \
		--zsh 'eval "$(basalt global init zsh)"' \
		--sh 'eval "$(basalt global init sh)"' \
		--tcsh 'basalt global init fish | source'
}

util.if_file_sourced || _setup "$@"
