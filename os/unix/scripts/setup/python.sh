#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	if util.confirm 'Setup Python?'; then
		setup.python
	fi
}

setup.python() {
	if ! util.is_cmd 'pip'; then
		core.print_info "Installing pip"
		python3 -m ensurepip --upgrade
	fi
	python3 -m pip install --upgrade pip

	python3 -m pip install wheel


	if ! util.is_cmd 'pipx'; then
		core.print_info "Installing pipx"
		python3 -m pip install --user pipx
		python3 -m pipx ensurepath
	fi
}

main "$@"
