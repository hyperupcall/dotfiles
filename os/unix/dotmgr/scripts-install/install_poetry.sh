# shellcheck shell=bash

# Name:
# Install Poetry

main() {
	if util.confirm "Install Poetry?"; then
		curl -sSL https://install.python-poetry.org | python3 -
	fi
}

main "$@"
