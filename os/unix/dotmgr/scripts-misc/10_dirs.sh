# shellcheck shell=bash

# Name:
# dirs
#
# Description:
# Deal with:
# - Mounting file systems (if applicable)
# - Removing pre-existing dotfiles
# - Creating necessary directories and files
# - Creating necessary symlinks
# - Removing extraneous directories and files
# - Removing broken symlinks
# - Removing autoappended content to `~/.{profile,bashrc}`, etc.

{
	declare profile='desktop'

	# -------------------------------------------------------- #
	#                     MOUNT /STORAGE/UR                    #
	# -------------------------------------------------------- #
	if [ "$profile" = 'desktop' ]; then
		declare part_uuid="c875b5ca-08a6-415e-bc11-fc37ec94ab8f"
		declare mnt='/storage/ur'
		if ! grep -q "$mnt" /etc/fstab; then
			printf '%s\n' "PARTUUID=$part_uuid  $mnt  btrfs  defaults,noatime,X-mount.mkdir  0 0" \
				| sudo tee -a /etc/fstab >/dev/null
			sudo mount "$mnt"
		fi
	fi

	# -------------------------------------------------------- #
	#     REMOVE AUTOAPPENDED LINES IN SHELL STARTUP FILES     #
	# -------------------------------------------------------- #
	for file in ~/.profile ~/.bashrc ~/.bash_profile "${ZDOTDIR:-$HOME}/.zshrc" "${XDG_CONFIG_HOME:-$HOME/.config}/fish/config.fish"; do
		if [ ! -f "$file" ]; then
			continue
		fi

		declare file_string=
		while IFS= read -r line; do
			file_string+="$line"$'\n'

			if [[ "$line" == '# ---' ]]; then
				break
			fi
		done < "$file"; unset -v line

		printf '%s' "$file_string" > "$file"
	done; unset -v file
	core.print_info 'Cleaned shell dotfiles'

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
	must.dir "$HOME/.dotfiles/.home"
	must.dir "$HOME/.dotfiles/.repos"
	must.dir "$HOME/.dotfiles/.data"
	must.dir "$HOME/.gnupg"
	must.dir "$HOME/.ssh"
	must.dir "$XDG_STATE_HOME/history"
	must.dir "$XDG_STATE_HOME/Android/Sdk"
	must.dir "$XDG_DATA_HOME/maven"
	must.dir "$XDG_DATA_HOME"/nano/backups
	must.dir "$XDG_DATA_HOME/zsh"
	must.dir "$XDG_DATA_HOME/X11"
	must.dir "$XDG_DATA_HOME/xsel"
	must.dir "$XDG_DATA_HOME/tig"
	must.dir "$XDG_CONFIG_HOME/sage" # $DOT_SAGE
	must.dir "$XDG_CONFIG_HOME/less" # $LESSKEY
	must.dir "$XDG_CONFIG_HOME/Code - OSS/User"
	must.dir "$XDG_DATA_HOME/gq/gq-state" # $GQ_STATE
	must.dir "$XDG_DATA_HOME/sonarlint" # $SONARLINT_USER_HOME
	must.file "$XDG_CONFIG_HOME/yarn/config"
	must.file "$XDG_STATE_HOME/tig/history"
	must.file "$XDG_STATE_HOME/history/zsh_history" # ZSH's $HISTFILE
	chmod 0700 "$HOME/.gnupg"
	chmod 0700 "$HOME/.ssh"


	# -------------------------------------------------------- #
	#               REMOVE AUTOGENERATED DOTFILES              #
	# -------------------------------------------------------- #
	must.rm .bash_history
	must.rm .dir_colors
	must.rm .dircolors
	must.rm .flutter
	must.rm .flutter_tool_state
	must.rm .gitconfig
	must.rm .gmrun_history
	must.rm .inputrc
	must.rm .lesshst
	must.rm .mkshrc
	must.rm .pulse-cookie
	must.rm .pythonhist
	must.rm .sqlite_history
	must.rm .viminfo
	must.rm .wget-hsts
	must.rm .zlogin
	must.rm .zshenv
	must.rm .zshrc
	must.rm .zprofile
	must.rm .zcompdump


	# -------------------------------------------------------- #
	#                 CREATE HOME DIR SYMLINKS                 #
	# -------------------------------------------------------- #
	if [ "$profile" = 'desktop' ]; then
		must.link "$HOME/.dotfiles/.home/Documents/Programming/challenges" "$HOME/challenges"
		must.link "$HOME/.dotfiles/.home/Documents/Programming/experiments" "$HOME/experiments"
		must.link "$HOME/.dotfiles/.home/Documents/Programming/workspaces" "$HOME/workspaces"
		must.link "$HOME/.dotfiles/.home/Documents/Programming/Repositories/git" "$HOME/git"
		must.link "$HOME/.dotfiles/.home/Documents/Programming/Repositories/default" "$HOME/repos"
		must.link "$HOME/.dotfiles/.home/Documents/Programming/Repositories" "$HOME/groups"
	elif [ "$profile" = 'laptop' ]; then
		:
	fi

	# -------------------------------------------------------- #
	#                    CREATE BIN SYMLINKS                   #
	# -------------------------------------------------------- #
	core.shopt_push -s nullglob
	declare -a files=(~/.dotfiles/.bin/*)
	core.shopt_pop
	declare file=; for file in "${files[@]}"; do if [ -L "$file" ]; then
		unlink "$file"
	fi done; unset -v file

	core.shopt_push -s nullglob
	declare -a files=("$HOME/.dotfiles/.home/Documents/Programming/Repositories/Bash"/{bake,basalt,hookah,foxomate,glue,rho,shelldoc,shelltest,woof}/pkg/bin/*)
	core.shopt_pop
	declare file=; for file in "${files[@]}"; do
		ln -fs  "$file" ~/.dotfiles/.bin
	done; unset -v file

	ln -s "$HOME/.dotfiles/.home/Documents/Programming/Repositories/default/choose/target/debug/choose" ~/.dotfiles/.bin/choose
	must.link ~/.dotfiles/.data/dotmgr-src/target/debug/dotmgr ~/.dotfiles/.bin/dotmgr
	if [ "$profile" = 'desktop' ]; then
		must.link ~/repos/dotfox/dotfox ~/.dotfiles/.bin/dotfox
	fi


	# -------------------------------------------------------- #
	#                      CREATE SYMLINKS                     #
	# -------------------------------------------------------- #
	declare -r storage_home='/storage/ur/storage_home'
	declare -r storage_other='/storage/ur/storage_other'

	must.link "$XDG_CONFIG_HOME/X11/Xmodmap" "$HOME/.Xmodmap"
	must.link "$XDG_CONFIG_HOME/X11/Xresources" "$HOME/.Xresources"
	must.link "$XDG_CONFIG_HOME/Code/User/settings.json" "$XDG_CONFIG_HOME/Code - OSS/User/settings.json"

	declare -ra directories_default=(
		# ~/Desktop
		~/Downloads
		~/Templates ~/Public ~/Documents
		# ~/Music
		~/Pictures
		~/Videos
	)
	declare -ra directories_custom=(
		# ~/Desktop
		~/Dls
		~/Docs/Templates ~/Docs/Public ~/Docs
		# ~/Music
		~/Pics
		~/Vids
	)
	declare -ra directories_shared=(
		~/Desktop
		~/Music
	)
	# Use 'cp -f' for "$XDG_CONFIG_HOME/user-dirs.dirs"; otherwise unlink/link operation races
	if [ "$profile" = 'desktop' ]; then
		cp -f "$HOME/.dotfiles/os/unix/user/.config/user-dirs.dirs/user-dirs-custom.conf" "$XDG_CONFIG_HOME/user-dirs.dirs"

		# XDG User Directories
		declare dir=
		for dir in "${directories_default[@]}"; do
			must.rmdir "$dir"
		done; unset -v dir
		for dir in "${directories_shared[@]}"; do
			must.dir "$dir"
		done; unset -v dir
		must.link "$storage_home/Desktop" "$HOME/Desktop"
		must.link "$storage_home/Dls" "$HOME/Dls"
		must.link "$storage_home/Docs" "$HOME/Docs"
		must.link "$storage_home/Music" "$HOME/Music"
		must.link "$storage_home/Pics" "$HOME/Pics"
		must.link "$storage_home/Vids" "$HOME/Vids"

		# Populate ~/.dotfiles/.home/
		must.link "$HOME/Desktop" "$HOME/.dotfiles/.home/Desktop"
		must.link "$HOME/Dls" "$HOME/.dotfiles/.home/Downloads"
		must.link "$HOME/Docs" "$HOME/.dotfiles/.home/Documents"
		must.link "$HOME/Music" "$HOME/.dotfiles/.home/Music"
		must.link "$HOME/Pics" "$HOME/.dotfiles/.home/Pictures"
		must.link "$HOME/Vids" "$HOME/.dotfiles/.home/Videos"
		must.link "$HOME/.cache" "$HOME/.dotfiles/.home/xdg_cache_dir"
		must.link "$HOME/.config" "$HOME/.dotfiles/.home/xdg_config_dir"
		must.link "$HOME/.local/state" "$HOME/.dotfiles/.home/xdg_state_dir"
		must.link "$HOME/.local/share" "$HOME/.dotfiles/.home/xdg_data_dir"

		# Miscellaneous
		must.link "$storage_other/mozilla" "$HOME/.mozilla"
		if [ ! -L "$HOME/.ssh" ]; then rm -f "$HOME/.ssh/known_hosts"; fi
		must.link "$storage_other/ssh" "$HOME/.ssh"
		must.link "$storage_other/BraveSoftware" "$XDG_CONFIG_HOME/BraveSoftware"
		must.link "$storage_other/fonts" "$XDG_CONFIG_HOME/fonts"
		must.link "$storage_other/Mailspring" "$XDG_CONFIG_HOME/Mailspring"
	else
		cp -f "$HOME/.dotfiles/os/unix/user/.config/user-dirs.dirs/user-dirs-default.conf" "$XDG_CONFIG_HOME/user-dirs.dirs"

		# XDG User Directories
		declare dir=
		for dir in "${directories_custom[@]}"; do
			must.rmdir "$dir"
		done; unset -v dir
		for dir in "${directories_shared[@]}"; do
			must.dir "$dir"
		done; unset -v dir
		must.dir "$HOME/Desktop"
		must.dir "$HOME/Downloads"
		must.dir "$HOME/Documents"
		must.dir "$HOME/Templates"
		must.dir "$HOME/Public"
		must.dir "$HOME/Music"
		must.dir "$HOME/Pictures"
		must.dir "$HOME/Videos"

		# Populate ~/.dotfiles/.home/
		must.link "$HOME/Desktop" "$HOME/.dotfiles/.home/Desktop"
		must.link "$HOME/Downloads" "$HOME/.dotfiles/.home/Downloads"
		must.link "$HOME/Documents" "$HOME/.dotfiles/.home/Documents"
		must.link "$HOME/Music" "$HOME/.dotfiles/.home/Music"
		must.link "$HOME/Pictures" "$HOME/.dotfiles/.home/Pictures"
		must.link "$HOME/Videos" "$HOME/.dotfiles/.home/Videos"

		# Miscellaneous
	fi

	# Must be last as they are dependent on previous symlinking
	must.dir "$HOME/.dotfiles/.home/Documents/Shared"
	must.dir "$HOME/.dotfiles/.home/Pictures/Screenshots"
}
