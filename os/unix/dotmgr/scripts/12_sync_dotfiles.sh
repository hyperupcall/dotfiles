# shellcheck shell=bash

# Name:
# Sync dotfiles
#
# Description:
# Executes dotfox with the right arguments. The command is shown before it is ran
# Before executing, however, it removes ~/.config/user-dirs.dirs

{
	declare dotfox=
	if util.is_cmd dotfox; then
		dotfox='dotfox'
	else
		core.print_warn "Using dotfox from ~/.bootstrap"
		dotfox="$HOME/.bootstrap/dotfox/dotfox"
	fi

	util.run "$dotfox" --config-dir="$HOME/.dotfiles/os/*nix/user/.config/dotfox" --deployment=all.sh deploy
	util.run "$dotfox" --config-dir="$HOME/.dotfiles/os/*nix/user/.config/dotfox" --deployment=all.sh status
}
