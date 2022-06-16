# shellcheck shell=bash

# Name:
# Deploy Dotfiles
#
# Description:
# Executes dotfox with the right arguments. The command is shown before it is ran
# Before executing, however, it removes ~/.config/user-dirs.dirs

helper.dotfox_deploy() {
	local dotfox=
	if util.is_cmd dotfox; then
		dotfox='dotfox'
	else
		core.print_warn "Using dotfox from ~/.bootstrap"
		dotfox="$HOME/.bootstrap/dotfox/dotfox"
	fi

	"$dotfox" --config-dir="$HOME/.dots/user/.config/dotfox" --deployment=all.sh deploy
}

