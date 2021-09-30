# shellcheck shell=bash

if command -v node &>/dev/null; then
	eval "$(node --completion-bash)"
fi
