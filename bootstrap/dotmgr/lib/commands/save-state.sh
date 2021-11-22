# shellcheck shell=bash

subcmd() {
	exts="$(code --list-extensions)"
	if [[ $(wc -l <<< "$exts") -gt 10 ]]; then
		cat <<< "$exts" > ~/.dots/state/vscode-extensions.txt
	fi
}
