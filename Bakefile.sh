# shellcheck shell=bash

# config: big-print=off
task.init() {
	git config --local filter.npmrc-clean.clean "$PWD/user/.config/npm/npmrc-clean.sh"
	git config --local filter.slack-term-config-clean.clean "$PWD/user/.config/slack-term/slack-term-config-clean.sh"
	git config --local filter.oscrc-clean.clean "$PWD/user/.config/osc/oscrc-clean.sh"
}

task.build() {
	cd "$BAKE_ROOT/user/.config/X11/resources"
	printf '%s\n' "! GENERATERD BY 'bake build'" > uxterm.Xresources
	sed 's/XTerm/UXTerm/g' xterm.Xresources >> uxterm.Xresources
}

task.update-subtree() {
	git subtree -P vendor/bats-all --squash pull 'https://github.com/hyperupcall/bats-all' HEAD
}

task.test() {
	cd ./user/.config/shell/modules && bats -p .
}

task.commit() {
	git commit -m "update: $(date "+%B %d, %Y (%H:%M)")" "$@"
}
