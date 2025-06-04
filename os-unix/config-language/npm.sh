#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

declare -g g_name='npm dependencies'

main() {
	npm i -g yarn pnpm
	yarn global add pnpm
	yarn global add diff-so-fancy
	yarn global add graphqurl
}

util.if_file_sourced || _setup "$@"
