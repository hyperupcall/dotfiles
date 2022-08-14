# shellcheck shell=bash

# Name:
# dconf
#
# Description:
# Updates dconf database with configuration. This includes:
# - Keyboard shortcuts for DE and applications
# - Settings for DE and applications

main() {
	dotmgr.get_profile
	local profile="$REPLY"

	# -------------------------------------------------------- #
	#                DESKTOP ENVIRONMENT TWEAKS                #
	# -------------------------------------------------------- #
	set-json-key() {
		local file="$1"
		local key="$2"
		local value="$3"

		mv "$file"{,.orig}
		jq -r "$key |= $value" "$file.orig" > "$file"
		rm "$file.orig"
	}

	if [ -n "$(dconf list /org/nemo/)" ]; then
		gsettings set org.nemo.preferences.menu-config selection-menu-copy 'false'
		gsettings set org.nemo.preferences.menu-config selection-menu-cut 'false'
		gsettings set org.nemo.preferences.menu-config selection-menu-paste 'false'
		gsettings set org.nemo.preferences.menu-config selection-menu-duplicate 'false'
		gsettings set org.nemo.preferences.menu-config selection-menu-open-in-new-tab 'false'
		gsettings set org.nemo.preferences show-advanced-permissions 'true'
		gsettings set org.nemo.preferences default-folder-viewer "'list-view'"
	fi

	hotkeys.apply_screenshots() {
		# 1. Screenshot
		# 2. Screenshot clip (interactive)
		# 3. Window screenshot
		# 4. Windows screenshot clip (interactive)
		case $1 in
		cinnamon)
			;;
		mate)
			;;
		gnome)
			# Old ones?
			# gsettings set org.gnome.settings-daemon.plugins.media-keys screenshot "['<Super><Shift>p']"
			# gsettings set org.gnome.settings-daemon.plugins.media-keys screenshot-clip "['<Super>p']"
			# gsettings set org.gnome.settings-daemon.plugins.media-keys window-screenshot "['<Super><Alt>p']"
			# gsettings set org.gnome.settings-daemon.plugins.media-keys window-screenshot-clip "['<Super><Alt><Shift>p']"

			# Fedora, etc.
			gsettings set org.gnome.shell.keybindings screenshot "['<Shift><Super>p']"
			gsettings set org.gnome.shell.keybindings show-screenshot-ui "['<Super>p']"
			gsettings set org.gnome.shell.keybindings screenshot-window "['<Alt><Super>p']"
			;;
		esac
	}

	if [ "$XDG_SESSION_DESKTOP" = 'cinnamon' ]; then
		local file="$HOME/.cinnamon/configs/menu@cinnamon.org/0.json"
		local image_file=
		for image_file in '/storage/ur/storage_home/Pics/Icons/Panda1_Transprent.png' "$HOME/Dropbox/Common/Icons/Panda1_Transparent.png"; do
			if [ -f "$image_file" ]; then
				set-json-key "$file" '."menu-icon".value' "\"$image_file\""
			fi
		done; unset -v image_file
		set-json-key "$file" '."menu-icon-size".value' '"36"'
		set-json-key "$file" '."menu-label".value' '""'


		local file="$HOME/.cinnamon/configs/calendar@cinnamon.org/17.json"
		set-json-key "$file" '."use-custom-format".value' 'false'

		gsettings set org.cinnamon.desktop.wm.preferences mouse-button-modifier '"<Super>"'
		gsettings set org.cinnamon.desktop.interface clock-show-date 'true'
		gsettings set org.cinnamon.desktop.keybindings looking-glass-keybinding "['']"
		gsettings set org.cinnamon.desktop.keybindings magnifier-zoom-in "['']"
		gsettings set org.cinnamon.desktop.keybindings magnifier-zoom-out "['']"
		gsettings set org.cinnamon.desktop.keybindings.media-keys area-screenshot "['<Super><Shift>p']"
		gsettings set org.cinnamon.desktop.keybindings.media-keys area-screenshot-clip "['<Super>p']"
		gsettings set org.cinnamon.desktop.keybindings.media-keys restart-cinnamon "['']"
		gsettings set org.cinnamon.desktop.keybindings.media-keys screenreader "['XF86ScreenSaver']" # Default includes '<Control><Alt>l'
		gsettings set org.cinnamon.desktop.keybindings.media-keys screensaver "['']"
		gsettings set org.cinnamon.desktop.keybindings.media-keys video-outputs "['XF86Display']" # Default includes '<Super>p'
		gsettings set org.cinnamon.desktop.keybindings.media-keys screenshot "['<Super><Control><Shift>p']"
		gsettings set org.cinnamon.desktop.keybindings.media-keys screenshot-clip "['<Super><Control>p']"
		gsettings set org.cinnamon.desktop.keybindings.media-keys terminal "['<Super>Return']"
		gsettings set org.cinnamon.desktop.keybindings.media-keys shutdown "['XF86PowerOff']"
		gsettings set org.cinnamon.desktop.keybindings.media-keys video-rotation-lock "['']"
		gsettings set org.cinnamon.desktop.keybindings.media-keys window-screenshot "['<Super><Alt>p']"
		gsettings set org.cinnamon.desktop.keybindings.media-keys window-screenshot-clip "['<Super><Alt><Shift>p']"
		# General window manager hotkeys
		gsettings set org.cinnamon.desktop.keybindings.wm toggle-fullscreen "['<Super>f']"
		gsettings set org.cinnamon.desktop.keybindings.wm toggle-maximized "['<Super><Shift>f']"
		# Navigating workspaces
		gsettings set org.cinnamon.desktop.keybindings.wm switch-to-workspace-right "['<Super><Control>l', '<Super><Control>Up']"
		gsettings set org.cinnamon.desktop.keybindings.wm switch-to-workspace-down "['<Super><Control>j', '<Super><Control>Down']"
		gsettings set org.cinnamon.desktop.keybindings.wm switch-to-workspace-left "['<Super><Control>h', '<Super><Control>Left']"
		gsettings set org.cinnamon.desktop.keybindings.wm switch-to-workspace-up "['<Super><Control>k', '<Super><Control>Up']"
		# Moving window to workspace
		gsettings set org.cinnamon.desktop.keybindings.wm move-to-workspace-up "['<Super><Control><Shift>k', '<Super><Control><Shift>Up']"
		gsettings set org.cinnamon.desktop.keybindings.wm move-to-workspace-right "['<Super><Control><Shift>l', '<Super><Control><Shift>Right']"
		gsettings set org.cinnamon.desktop.keybindings.wm move-to-workspace-down "['<Super><Control><Shift>j', '<Super><Control><Shift>Down']"
		gsettings set org.cinnamon.desktop.keybindings.wm move-to-workspace-left "['<Super><Control><Shift>h', '<Super><Control><Shift>Left']"
		# Moving window in workspace, `push-snap` is identical to `push-tile` except for the fact that snapped windows won't get covered by other maximized windows
		gsettings set org.cinnamon.desktop.keybindings.wm push-snap-up "['']"
		gsettings set org.cinnamon.desktop.keybindings.wm push-snap-right "['']"
		gsettings set org.cinnamon.desktop.keybindings.wm push-snap-down "['']"
		gsettings set org.cinnamon.desktop.keybindings.wm push-snap-left "['']"
		gsettings set org.cinnamon.desktop.keybindings.wm push-tile-up "['<Super><Alt>k', '<Super><Alt>Up']"
		gsettings set org.cinnamon.desktop.keybindings.wm push-tile-right "['<Super><Alt>l', '<Super><Alt>Right']"
		gsettings set org.cinnamon.desktop.keybindings.wm push-tile-down "['<Super><Alt>j', '<Super><Alt>Down']"
		gsettings set org.cinnamon.desktop.keybindings.wm push-tile-left "['<Super><Alt>h', '<Super><Alt>Left']"
	elif [ "$XDG_SESSION_DESKTOP" = 'mate' ]; then
		gsettings set org.mate.Marco.general mouse-button-modifier '<Super>'
		gsettings set org.mate.Marco.global-keybindings run-command-screenshot '<Mod4>p'
		gsettings set org.mate.Marco.global-keybindings.run-command-window-screenshot '<Super><Alt>p'
		gsettings set org.mate.Marco.global-keybindings run-command-terminal '<Mod4>Return'
		gsettings set org.mate.SettingsDaemon.plugins.media-keys power ''
		gsettings set org.mate.SettingsDaemon.plugins.media-keys screensaver ''

		gsettings set org.mate.terminal.global use-mnemonics 'false'
		gsettings set org.mate.terminal.global use-menu-accelerators 'false'
	elif [ "$XDG_SESSION_DESKTOP" = 'gnome' ]; then
		gsettings set org.gnome.desktop.wm.keybindings minimize "[]"
		gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-last "[]"
		gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-1 "[]"
		gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-last "[]"
		gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-1 "[]"
		gsettings set org.gnome.desktop.wm.keybindings unmaximize "[]"
		gsettings set org.gnome.mutter.keybindings switch-monitor "['XF86Display']"

		gsettings set org.gnome.settings-daemon.plugins.media-keys screensaver "[]"
		gsettings set org.gnome.settings-daemon.plugins.media-keys screensaver-static "[]"

		hotkeys.apply_screenshots "$XDG_SESSION_DESKTOP"

		gsettings set org.gnome.desktop.wm.keybindings show-desktop "['<Super>d']"

		gsettings set org.gnome.desktop.wm.keybindings toggle-fullscreen "['<Super>f']"
		gsettings set org.gnome.desktop.wm.keybindings toggle-maximized "['<Super><Shift>f']"
		# Navigating workspaces
		gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-right "['<Super><Control>l', '<Super><Control>Up']"
		gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-down "['<Super><Control>j', '<Super><Control>Down']"
		gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-left "['<Super><Control>h', '<Super><Control>Left']"
		gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-up "['<Super><Control>k', '<Super><Control>Up']"
		# Moving window to workspace
		gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-up "['<Super><Control><Shift>k', '<Super><Control><Shift>Up']"
		gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-right "['<Super><Control><Shift>l', '<Super><Control><Shift>Right']"
		gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-down "['<Super><Control><Shift>j', '<Super><Control><Shift>Down']"
		gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-left "['<Super><Control><Shift>h', '<Super><Control><Shift>Left']"
	elif [ "$XDG_SESSION_DESKTOP" = 'pop' ]; then
		:
	elif [ -z "$XDG_SESSION_DESKTOP" ]; then
		core.print_warn "Variable '\$XDG_SESSION_DESKTOP' is empty"
	fi

	# TERMINAL
	gsettings set guake.style.background transparency '60'
	gsettings set guake.keybindings.global show-hide ''
	gsettings set guake.keybindings.local previous-tab '<Primary><Alt>h'
	gsettings set guake.keybindings.local next-tab '<Primary><Alt>l'
	gsettings set guake.keybindings.local move-tab-left '<Primary><Shift><Alt>h'
	gsettings set guake.keybindings.local move-tab-right '<Primary><Shift><Alt>l'
	for n in {1..9}; do
		gsettings set guake.keybindings.local switch-tab"$n" "<Primary>$n"
	done; unset -v n
	gsettings set guake.keybindings.local new-tab-home ''
	gsettings set guake.keybindings.local close-tab ''
	gsettings set guake.keybindings.local quit ''
	gsettings set guake.keybindings.local switch-tab10 ''
	gsettings set guake.keybindings.local switch-tab-last ''
	gsettings set guake.keybindings.local search-on-web ''
}
