#!/usr/bin/env bash

# Name:
# Install Python stuff

source "${0%/*}/../source.sh"

main() {
	if util.confirm 'Install Python?'; then
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

		if ! util.is_cmd 'poetry'; then
			core.print_info "Installing poetry"
			util.req 'https://install.python-poetry.org' | python3 -
		fi
	fi
}

main "$@"
