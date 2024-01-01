#!/usr/bin/env bash

source "${0%/*}/../source.sh"
main() {
	if util.confirm 'Install Rtx?'; then
		install.rtx
	fi
}

install.rtx() {
	curl 'https://rtx.jdx.dev/install.sh' | sh
}

main "$@"
