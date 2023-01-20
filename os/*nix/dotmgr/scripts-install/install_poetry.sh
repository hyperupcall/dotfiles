# shellcheck shell=bash

# Name:
# Install Poetry

{
	if util.confirm "Install Poetry?"; then
		curl -sSL https://install.python-poetry.org | python3 -
	fi
}
