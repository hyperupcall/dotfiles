# shellcheck shell=bash

# Most completions riside within the configuration fo dotshellgen
# TODO move to dotshellgen
if command -v node &>/dev/null; then
	source <(node --completion-bash)
fi
