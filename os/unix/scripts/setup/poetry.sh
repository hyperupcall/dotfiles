#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	if util.confirm "Install Poetry?"; then
		curl -sSL https://install.python-poetry.org | python3 -
	fi
}

main "$@"
