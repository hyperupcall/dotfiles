# shellcheck shell=bash

task.init() {
	git config set --local filter.npmrc-clean.clean './os-unix/config-language/.config/npm/npmrc-clean.sh'
	git config set --local filter.oscrc-clean.clean './os-unix/config-tools/.config/osc/oscrc-clean.sh'
}

task.build() {
	grep -r "/home/edwin" ./os-unix/config-*
	grep -r "/storage" ./os-unix/config-*
	cd "./os-unix/config-linux-rice/.config/X11/resources" || exit
	printf '%s\n' "! GENERATERD BY 'bake build'" > uxterm.Xresources
	sed 's/XTerm/UXTerm/g' xterm.Xresources >> uxterm.Xresources
}

task.lint() {
	yamllint -c ./.yamllint.yaml .
}

task.test() {
	bats -p './os-unix/config-shell/.config/sh'
	~/scripts/lint-scripts.py
}

task.commit() {
	local date=
	date=$(date '+%Y.%m.%d')
	git commit -m "$date" "$@"
}
