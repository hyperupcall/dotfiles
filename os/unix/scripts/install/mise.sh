#!/usr/bin/env bash

source "${0%/*}/../source.sh"
main() {
	if util.confirm 'Install Mise?'; then
		install.mise
	fi
}

install.mise() {
	curl https://mise.jdx.dev/install.sh | sh
}

main "$@"
