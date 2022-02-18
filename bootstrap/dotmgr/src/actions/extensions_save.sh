# shellcheck shell=bash

# Name:
# Save extensions
#
# Description:
# Saves extensions

action() {
	local exts
	exts=$(code --list-extensions)

	if [[ $(wc -l <<< "$exts") -gt 10 ]]; then
		cat <<< "$exts" > ~/.dots/state/vscode-extensions.txt
	fi
}
