# shellcheck shell=bash

# Name:
# Idempotent
#
# Description:
# Performs an essentially idempotent operation to setup desktop. Prunes the homefolder for improper dotfiles like '~/.bash_history'. It also makes directories required for things to work properly like '~/.config/yarn/config'. Lastly, it also symlinks directories that are out of the scope of dotfox. More specifically, this symlinks the XDG user directories, ~/.ssh, ~/.config/BraveSoftware, etc. to the shared drive mounted under /storage

action() {
	# -------------------------------------------------------- #
	#                   STRIP SHELL DOTFILES                   #
	# -------------------------------------------------------- #
	for file in ~/.profile ~/.bashrc ~/.bash_profile "${ZDOTDIR:-$HOME}/.zshrc" "${XDG_CONFIG_HOME:-$HOME/.config}/fish/config.fish"; do
		if [ ! -f "$file" ]; then
			continue
		fi

		local file_string=
		while IFS= read -r line; do
			file_string+="$line"$'\n'

			if [[ "$line" == '# ---' ]]; then
				break
			fi
		done < "$file"; unset -v line

		printf '%s' "$file_string" > "$file"
	done; unset -v file
	print.info "Cleaned shell dotfiles"


	# -------------------------------------------------------- #
	#                  REMOVE BROKEN SYMLINKS                  #
	# -------------------------------------------------------- #
	for file in "$HOME"/*; do
		if [ -L "$file" ] && [ ! -e "$file" ]; then
			unlink "$file"
		fi
	done


	# -------------------------------------------------------- #
	#               CREATE DIRECTORIES AND FILES               #
	# -------------------------------------------------------- #
	must_dir "$HOME/.dots/.bin"
	must_dir "$HOME/.dots/.home"
	must_dir "$HOME/.dots/.repos"
	must_dir "$HOME/.gnupg"
	must_dir "$HOME/.ssh"
	must_dir "$XDG_STATE_HOME/history"
	must_dir "$XDG_DATA_HOME/maven"
	must_dir "$XDG_DATA_HOME"/vim/{undo,swap,backup}
	must_dir "$XDG_DATA_HOME"/nano/backups
	must_dir "$XDG_DATA_HOME/zsh"
	must_dir "$XDG_DATA_HOME/X11"
	must_dir "$XDG_DATA_HOME/xsel"
	must_dir "$XDG_DATA_HOME/tig"
	must_dir "$XDG_CONFIG_HOME/sage" # $DOT_SAGE
	must_dir "$XDG_CONFIG_HOME/less" # $LESSKEY
	must_dir "$XDG_CONFIG_HOME/Code - OSS/User"
	must_dir "$XDG_DATA_HOME/gq/gq-state" # $GQ_STATE
	must_dir "$XDG_DATA_HOME/sonarlint" # $SONARLINT_USER_HOME
	must_dir "$XDG_DATA_HOME/nvm"
	must_file "$XDG_CONFIG_HOME/yarn/config"
	must_file "$XDG_DATA_HOME/tig/history"
	chmod 0700 "$HOME/.gnupg"
	chmod 0700 "$HOME/.ssh"


	# -------------------------------------------------------- #
	#               REMOVE AUTOGENERATED DOTFILES              #
	# -------------------------------------------------------- #
	must_rm .bash_history
	must_rm .dir_colors
	must_rm .dircolors
	must_rm .flutter
	must_rm .flutter_tool_state
	must_rm .gitconfig
	must_rm .gmrun_history
	must_rm .inputrc
	must_rm .lesshst
	must_rm .mkshrc
	must_rm .pulse-cookie
	must_rm .pythonhist
	must_rm .sqlite_history
	must_rm .viminfo
	must_rm .wget-hsts
	must_rm .zlogin
	must_rm .zshenv
	must_rm .zshrc
	must_rm .zprofile
	must_rm .zcompdump


	# -------------------------------------------------------- #
	#                      CREATE SYMLINKS                     #
	# -------------------------------------------------------- #
	local -r storage='/storage'
	local -r storage_home='/storage/ur/storage_home'
	local -r storage_other='/storage/ur/storage_other'

	must_link "$HOME/.dots/user/scripts" "$HOME/scripts"
	must_link "$XDG_CONFIG_HOME/X11/Xcompose" "$HOME/.Xcompose"
	must_link "$XDG_CONFIG_HOME/X11/Xmodmap" "$HOME/.Xmodmap"
	must_link "$XDG_CONFIG_HOME/X11/Xresources" "$HOME/.Xresources"
	must_link "$XDG_CONFIG_HOME/Code/User/settings.json" "$XDG_CONFIG_HOME/Code - OSS/User/settings.json"

	local -ra directoriesDefault=(
		# ~/Desktop
		~/Downloads
		~/Templates ~/Public ~/Documents
		# ~/Music
		~/Pictures
		~/Videos
	)

	local -ra directoriesCustom=(
		# ~/Desktop
		~/Dls
		~/Docs/Templates ~/Docs/Public ~/Docs
		# ~/Music
		~/Pics
		~/Vids
	)

	local -ra directoriesShared=(
		~/Desktop
		~/Music
	)

	if [ -L "$XDG_CONFIG_HOME/user-dirs.dirs" ]; then
		unlink "$XDG_CONFIG_HOME/user-dirs.dirs"
	else
		rm -f "$XDG_CONFIG_HOME/user-dirs.dirs"
	fi

	if [ -d "$storage" ]; then
		must_link "$HOME/.dots/user/.config/user-dirs.dirs/user-dirs-custom.conf" "$XDG_CONFIG_HOME/user-dirs.dirs"

		# XDG User Directories
		local dir=
		for dir in "${directoriesDefault[@]}"; do
			must_rmdir "$dir"
		done; unset -v dir
		for dir in "${directoriesShared[@]}"; do
			must_dir "$dir"
		done; unset -v dir
		must_link "$storage_home/Desktop" "$HOME/Desktop"
		must_link "$storage_home/Dls" "$HOME/Dls"
		must_link "$storage_home/Docs" "$HOME/Docs"
		must_link "$storage_home/Music" "$HOME/Music"
		must_link "$storage_home/Pics" "$HOME/Pics"
		must_link "$storage_home/Vids" "$HOME/Vids"

		# Populate ~/.dots/.home/
		must_link "$HOME/Desktop" "$HOME/.dots/.home/Desktop"
		must_link "$HOME/Dls" "$HOME/.dots/.home/Downloads"
		must_link "$HOME/Docs" "$HOME/.dots/.home/Documents"
		must_link "$HOME/Music" "$HOME/.dots/.home/Music"
		must_link "$HOME/Pics" "$HOME/.dots/.home/Pictures"
		must_link "$HOME/Vids" "$HOME/.dots/.home/Videos"

		# Miscellaneous
		must_link "$storage_other/mozilla" "$HOME/.mozilla"
		must_link "$storage_other/ssh" "$HOME/.ssh"
		must_link "$storage_other/BraveSoftware" "$XDG_CONFIG_HOME/BraveSoftware"
		must_link "$storage_other/calcurse" "$XDG_CONFIG_HOME/calcurse"
		must_link "$storage_other/fonts" "$XDG_CONFIG_HOME/fonts"
		must_link "$storage_other/password-store" "$XDG_DATA_HOME/password-store"
	else
		must_link "$HOME/.dots/user/.config/user-dirs.dirs/user-dirs-regular.conf" "$XDG_CONFIG_HOME/user-dirs.dirs"

		# XDG User Directories
		local dir=
		for dir in "${directoriesCustom[@]}"; do
			must_rmdir "$dir"
		done; unset -v dir
		for dir in "${directoriesShared[@]}"; do
			must_dir "$dir"
		done; unset -v dir
		must_dir "$HOME/Desktop"
		must_dir "$HOME/Downloads"
		must_dir "$HOME/Documents"
		must_dir "$HOME/Templates"
		must_dir "$HOME/Public"
		must_dir "$HOME/Music"
		must_dir "$HOME/Pictures"
		must_dir "$HOME/Videos"

		# Populate ~/.dots/.home/
		must_link "$HOME/Desktop" "$HOME/.dots/.home/Desktop"
		must_link "$HOME/Downloads" "$HOME/.dots/.home/Downloads"
		must_link "$HOME/Documents" "$HOME/.dots/.home/Documents"
		must_link "$HOME/Music" "$HOME/.dots/.home/Music"
		must_link "$HOME/Pictures" "$HOME/.dots/.home/Pictures"
		must_link "$HOME/Videos" "$HOME/.dots/.home/Videos"
	fi

	if [ -d "$HOME/Docs/Programming" ]; then
		must_link "$HOME/Docs/Programming/challenges" "$HOME/challenges"
		must_link "$HOME/Docs/Programming/experiments" "$HOME/experiments"
		must_link "$HOME/Docs/Programming/git" "$HOME/git"
		must_link "$HOME/Docs/Programming/repos" "$HOME/repos"
		must_link "$HOME/Docs/Programming/workspaces" "$HOME/workspaces"

		local file=
		for file in ~/.dots/.bin/*; do unlink "$file"; done
		for file in "$HOME/Docs/Programming/repos/Groups/Bash"/{bake,basalt,choose,hookah,foxomate,glue,rho,shelldoc,shelltest,woof}/pkg/bin/*; do
			ln -fs  "$file" ~/.dots/.bin
		done; unset -v file
	else
		local file=
		for file in ~/.dots/.bin/*; do unlink "$file"; done
		for file in "$HOME/Documents"/{bake,basalt,choose,hookah,foxomate,glue,rho,shelldoc,shelltest,woof}/pkg/bin/*; do
			ln -fs "$file" ~/.dots/.bin
		done; unset -v file
	fi

	# Dependencies of symlinking
	must_dir "$HOME/.dots/.home/Pictures/Screenshots"


	# TODO
	# -------------------------------------------------------- #
	#                    COPY ROOT DOTFILES                    #
	# -------------------------------------------------------- #
	# shopt -s extglob
	# local {src,dest}File=
	# for srcFile in ~/.dots/system/**; do
	# 	destFile=${srcFile#*/.dots/system}

	# 	if [ -d "$srcFile" ]; then
	# 		continue
	# 	fi

	# 	if [ "${destFile::8}" = '/efi/EFI' ]; then
	# 		continue
	# 	fi

	# 	if [[ $srcFile == *ignore* ]]; then
	# 		continue
	# 	fi

	# 	printf '%s -> %s\n' "$srcFile" "$destFile"
	# done; unset -v f

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

	# gsettings set org.gnome.libgnomekbd.keyboard layouts "['us', 'us\tdvorak']"
	# gsettings set org.gnome.libgnomekbd.keyboard options "['grp\tgrp:win_space_toggle']"
	# gsettings set org.gnome.gnome-screenshot auto-save-directory "'$HOME/.dots/.home/Pictures/Screenshots'"

	if [ "$XDG_SESSION_DESKTOP" = 'cinnamon' ]; then
		# gsettings set /org/cinnamon/enabled-applets "['panel1:left:0:menu@cinnamon.org:0', 'panel1:left:1:separator@cinnamon.org:1', 'panel1:left:2:expo@cinnamon.org:2', 'panel1:left:3:show-desktop@cinnamon.org:3', 'panel1:left:4:separator@cinnamon.org:4', 'panel1:left:5:grouped-window-list@cinnamon.org:5', 'panel1:right:1:notifications@cinnamon.org:6', 'panel1:right:2:workspace-switcher@cinnamon.org:7', 'panel1:right:3:windows-quick-list@cinnamon.org:8', 'panel1:right:4:separator@cinnamon.org:9', 'panel1:right:5:systray@cinnamon.org:10', 'panel1:right:6:separator@cinnamon.org:11', 'panel1:right:7:removable-drives@cinnamon.org:12', 'panel1:right:8:network@cinnamon.org:13', 'panel1:right:9:sound@cinnamon.org:14', 'panel1:right:10:power@cinnamon.org:15', 'panel1:right:11:inhibit@cinnamon.org:16', 'panel1:right:12:calendar@cinnamon.org:17', 'panel1:right:13:user@cinnamon.org:18', 'panel1:right:0:keyboard@cinnamon.org:19']"

		local file="$HOME/.cinnamon/configs/menu@cinnamon.org/0.json"
		local image_file=
		for image_file in '/storage/ur/storage_home/Pics/Icons/Panda1_Transprent.png' "$HOME/Dropbox/Pictures/Icons/Panda1_Transparent.png"; do
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
		gsettings set org.cinnamon.desktop.keybindings media-keys.area-screenshot "['<Super><Shift>p']"
		gsettings set org.cinnamon.desktop.keybindings media-keys.area-screenshot-clip "['<Super>p']"
		gsettings set org.cinnamon.desktop.keybindings media-keys.restart-cinnamon "['']"
		gsettings set org.cinnamon.desktop.keybindings media-keys.screenreader "['']"
		gsettings set org.cinnamon.desktop.keybindings media-keys.screenreader "['XF86ScreenSaver']" # Default includes '<Control><Alt>l'
		gsettings set org.cinnamon.desktop.keybindings media-keys.screensaver "['']"
		gsettings set org.cinnamon.desktop.keybindings media-keys.video-outputs "['XF86Display']" # Default includes '<Super>p'
		gsettings set org.cinnamon.desktop.keybindings media-keys.screenshot "['<Super><Control><Shift>p']"
		gsettings set org.cinnamon.desktop.keybindings media-keys.screenshot-clip "['<Super><Control>p']"
		gsettings set org.cinnamon.desktop.keybindings media-keys.terminal "['<Super>Return']"
		gsettings set org.cinnamon.desktop.keybindings media-keys.shutdown "['XF86PowerOff']"
		gsettings set org.cinnamon.desktop.keybindings media-keys.video-rotation-lock "['']"
		gsettings set org.cinnamon.desktop.keybindings media-keys.window-screenshot "['<Super><Alt>p']"
		gsettings set org.cinnamon.desktop.keybindings media-keys.window-screenshot-clip "['<Super><Alt><Shift>p']"
		# General window manager hotkeys
		gsettings set org.cinnamon.desktop.keybindings.wm toggle-fullscreen "['<Super><Shift>f']"
		gsettings set org.cinnamon.desktop.keybindings.wm toggle-maximized "['<Super>f']"
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
	elif [ -z "$XDG_SESSION_DESKTOP" ]; then
		print.warn "Variable '\$XDG_SESSION_DESKTOP' is empty"
	fi
}

must_rm() {
	util_get_file "$1"
	local file="$REPLY"

	if [ -f "$file" ]; then
		local output=
		if output=$(rm -f -- "$file" 2>&1); then
			print.info "Removed file '$file'"
		else
			print.warn "Failed to remove file '$file'"
			printf '  -> %s\n' "$output"
		fi
	fi
}

must_rmdir() {
	util_get_file "$1"
	local dir="$REPLY"

	if [ -d "$dir" ]; then
		local output=
		if output=$(rmdir -- "$dir" 2>&1); then
			print.info "Removed directory '$dir'"
		else
			print.warn "Failed to remove directory '$dir'"
			printf '  -> %s\n' "$output"
		fi
	fi
}

must_dir() {
	util_get_file "$1"
	local dir="$REPLY"

	if [ ! -d "$dir" ]; then
		local output=
		if output=$(mkdir -p -- "$dir" 2>&1); then
			print.info "Created directory '$dir'"
		else
			print.warn "Failed to create directory '$dir'"
			printf '  -> %s\n' "$output"
		fi
	fi
}

must_file() {
	util_get_file "$1"
	local file="$REPLY"

	if [ ! -f "$file" ]; then
		local output=
		if output=$(mkdir -p -- "${file%/*}" && touch -- "$file" 2>&1); then
			print.info "Created file '$file'"
		else
			print.warn "Failed to create file '$file'"
			printf '  -> %s\n' "$output"
		fi
	fi
}

must_link() {
	util_get_file "$1"
	local src="$REPLY"

	util_get_file "$2"
	local link="$REPLY"

	if [ -z "$1" ]; then
		print.warn "must_link: First parameter is emptys"
		return
	fi

	if [ -z "$2" ]; then
		print.warn "must_link: Second parameter is empty"
		return
	fi

	# Skip if already is correct
	if [ -L "$link" ] && [ "$(readlink "$link")" = "$src" ]; then
		return
	fi

	# If it is an empty directory (and not a symlink) automatically remove it
	if [ -d "$link" ] && [ ! -L "$link" ]; then
		local children=("$link"/*)
		if (( ${#children[@]} == 0)); then
			rmdir "$link"
		else
			print.warn "Skipping symlink from '$src' to '$link'"
			return
		fi
	fi
	if [ ! -e "$src" ]; then
		print.warn "Skipping symlink from '$src' to $link"
		return
	fi

	local output=
	if output=$(ln -sfT "$src" "$link" 2>&1); then
		print.info "Symlinking '$src' to $link"
	else
		print.warn "Failed to symlink from '$src' to '$link'"
		printf '  -> %s\n' "$output"
	fi
}

util_get_file() {
	if [[ ${1::1} == / ]]; then
		REPLY="$1"
	else
		REPLY="$HOME/$1"
	fi
}