#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	if util.confirm 'Configure npm dependencies?'; then
		configure.npm
	fi
}

configure.npm() {
	npm i -g yarn pnpm
	yarn global add pnpm
	yarn global add diff-so-fancy
	yarn global add npm-check-updates
	yarn global add graphqurl
	yarn global add http-server
}

main "$@"
