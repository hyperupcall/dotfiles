#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

main() {
	for arg; do case $arg in
		*)
			core.print_die "Invalid argument: \"$arg\""
			;;
		esac done
	unset -v arg

	# Create necessary directories.
	must.dir ~/.home
	must.dir ~/.dotfiles/.data/{bin,repos}
	must.dir ~/.local/bin

	# Install required dependencies.
	if [ ! -f ~/.dotfiles/.data/finished_bootstrap ]; then
		util.update_system
		util.install_by_setup --fn-prefix=dependencies 'Bootstrap' # TODO
		touch ~/.dotfiles/.data/finished_bootstrap
		core.print_info "Installed required dependencies"
	fi

	# Remove broken symlinks.
	for f in "$HOME"/*; do
		if [ -L "$f" ] && [ ! -e "$f" ]; then
			must.unlink "$f"
		fi
	done
	core.print_info 'Removed broken symlinks'

	# Remove distribution-specific dotfiles.
	must.dir ~/.bootstrap/distro-dotfiles
	for file in ~/.bash_login ~/.bash_logout ~/.bash_profile ~/.bashrc ~/.profile .dir_colors .dircolors; do
		if [[ ! -L "$file" && -f "$file" ]]; then
			mv "$file" ~/.bootstrap/distro-dotfiles
		fi
	done

	# Remove auto-appended lines in shell startup files.
	for file in ~/.profile ~/.bashrc ~/.bash_profile "${ZDOTDIR:-"$HOME"}/.zshrc" "${ZDOTDIR:-"$HOME"}/.zshenv" "$XDG_CONFIG_HOME/fish/config.fish"; do
		if [ ! -f "$file" ]; then
			continue
		fi

		local file_string=
		while IFS= read -r line; do
			file_string+="$line"$'\n'

			if [[ "$line" == '# ---' ]]; then
				break
			fi
		done <"$file"
		unset -v line

		printf '%s' "$file_string" >"$file"
		unset -v file_string
	done
	unset -v file
	core.print_info 'Cleaned shell dotfiles'

	# Create necessary symlinks in ~/scripts.
	must.dir ~/.dotfiles/.data/scripts
	must.link ~/.dotfiles/.data/scripts ~/scripts
	for file in ~/.dotfiles/hscripts/*; do
		ln -sf "$file" ~/scripts
	done
	unset -v file
	if [ -d "$_private_scripts_hidden" ]; then
		for file in "$_private_scripts_hidden"/*; do
			ln -sf "$file" ~/scripts
		done
		unset -v file
	fi

	# Create necessary symlinks in ~/.local/bin.
	must.dir ~/.local/bin
	for file in ~/.dotfiles/bin/*; do
		if [ -x "$file" ]; then
			ln -sf "$file" ~/.local/bin
		fi
	done
	unset -v file

	for file in ~/scripts/*; do
		if [ -L "$file" ] && [ ! -e "$file" ]; then
			must.unlink "$file"
			continue
		fi
		if [ -d "$file" ]; then
			core.shopt_push -s globstar
			for file2 in "$file"/**; do
				if [ -f "$file2" ]; then
					chmod +x "$file2"
				fi
			done
			core.shopt_pop
		else
			chmod +x "$file"
		fi
	done
	must.dir ~/scripts/setup
	for file in ~/.dotfiles/{config,setup}-*/*; do
		if [ -d "$file" ]; then
			local dir="$file"
			local dirname=${dir##*/}
			core.shopt_push -s nullglob
			local -a files=("$dir"/"$dirname"@(|-*).sh)
			core.shopt_pop
			for file2 in "${files[@]}"; do
				chmod +x "$file2"
				ln -sf "$file2" ~/scripts/setup/"${file2##*/}"
			done
		else
			local filename=${file##*/}
			if [[ "$filename" =~ ^[[:alnum:]-]+.sh$ ]]; then
				chmod +x "$file"
				ln -sf "$file" ~/scripts/setup/"$filename"
			fi
		fi
	done
	unset -v file
	core.print_info 'Created necessary symlinks in ~/scripts'

	# Set current computer profile.
	if [ -f ~/.dotfiles/.data/profile ]; then
		core.print_info 'Already set computer profile'
	else
		local cur=
		local options='desktop|laptop|other'
		while [[ $cur != @($options) ]]; do
			printf '%s' "Computer profile? ($options): "
			read -er cur
		done
		must.dir ~/.dotfiles/.data
		printf '%s\n' "$cur" >~/.dotfiles/.data/profile
	fi
	local computer_profile=
	computer_profile=$(<~/.dotfiles/.data/profile)

	# Set XDG user directories.
	if [[ $computer_profile == @(desktop|laptop) ]]; then
		must.dir ~/Other/{Desktop,Templates,Public}
		xdg-user-dirs-update --set DESKTOP ~/Other/Desktop
		xdg-user-dirs-update --set DOWNLOAD ~/Downloads
		xdg-user-dirs-update --set TEMPLATES ~/Other/Templates
		xdg-user-dirs-update --set PUBLICSHARE ~/Other/Public
		xdg-user-dirs-update --set DOCUMENTS ~/Documents
		xdg-user-dirs-update --set MUSIC ~/Music
		xdg-user-dirs-update --set PICTURES ~/Pictures
		xdg-user-dirs-update --set VIDEOS ~/Videos
	else
		xdg-user-dirs-update --set DESKTOP ~/Desktop
		xdg-user-dirs-update --set DOWNLOAD ~/Downloads
		xdg-user-dirs-update --set TEMPLATES ~/Templates
		xdg-user-dirs-update --set PUBLICSHARE ~/Public
		xdg-user-dirs-update --set DOCUMENTS ~/Documents
		xdg-user-dirs-update --set MUSIC ~/Music
		xdg-user-dirs-update --set PICTURES ~/Pictures
		xdg-user-dirs-update --set VIDEOS ~/Videos
	fi
	if [[ $computer_profile == @(desktop|laptop) ]]; then
		must.dir "$HOME/Other/AppImages"
		must.link "$HOME/Other/AppImages" ~/.home/AppImages
	else
		must.dir "$HOME/AppImages"
		must.link "$HOME/AppImages" ~/.home/AppImages
	fi

	# Symlink XDG base and user directories.
	(
		source "$XDG_CONFIG_HOME/user-dirs.dirs"
		must.dir ~/.home

		must.link "$XDG_DESKTOP_DIR" ~/.home/Desktop
		must.link "$XDG_DOWNLOAD_DIR" ~/.home/Downloads
		must.link "$XDG_TEMPLATES_DIR" ~/.home/Templates
		must.link "$XDG_PUBLICSHARE_DIR" ~/.home/Public
		must.link "$XDG_DOCUMENTS_DIR" ~/.home/Documents
		must.link "$XDG_MUSIC_DIR" ~/.home/Music
		must.link "$XDG_PICTURES_DIR" ~/.home/Pictures
		must.link "$XDG_VIDEOS_DIR" ~/.home/Videos

		must.link "$XDG_CACHE_HOME" ~/.home/xdg_cache_dir
		must.link "$XDG_CONFIG_HOME" ~/.home/xdg_config_dir
		must.link "$XDG_STATE_HOME" ~/.home/xdg_state_dir
		must.link "$XDG_DATA_HOME" ~/.home/xdg_data_dir

		must.dir "$XDG_CACHE_HOME"
		must.dir "$XDG_CONFIG_HOME"
		must.dir "$XDG_STATE_HOME"
		must.dir "$XDG_DATA_HOME"

		for f in ~/.home/*; do
			if [ -L "$f" ] && [ ! -e "$f" ]; then
				must.unlink "$f"
			fi
		done
		unset -v f
	)
	core.print_info 'Set and symlink XDG base and user directories'

	# Create necessary directories, files, and groups.
	must.dir "$XDG_STATE_HOME/Android/Sdk"
	must.dir "$XDG_STATE_HOME/history"
	must.dir "$XDG_STATE_HOME/nano/backups"
	must.dir "$XDG_DATA_HOME/tig"
	must.dir "$XDG_CONFIG_HOME/Code - OSS/User"
	must.dir "$XDG_CONFIG_HOME/spacemacs"
	must.file "$XDG_STATE_HOME/tig/history"
	must.file "$XDG_STATE_HOME/history/zsh_history" For # For ZSH $HISTFILE.
	must.user_in_group "$USER" 'docker'
	must.user_in_group "$USER" 'vboxusers'
	must.user_in_group "$USER" 'libvirt'
	must.user_in_group "$USER" 'kvm'
	must.user_in_group "$USER" 'input'

	# Remove default dotfiles. These are customized with environment variables.
	if [[ $computer_profile == @(desktop|laptop) ]]; then
		must.rm ~/.bash_history
		must.rm ~/.gitconfig
		must.rm ~/.gmrun_history
		must.rm ~/.mkshrc
		must.rm ~/.pythonhist
		must.rm ~/.sh_history
		must.rm ~/.sqlite_history
		must.rm ~/.sudo_as_admin_successful
		must.rm ~/.viminfo
		must.rm ~/.wget-hsts
		must.rm ~/.xsession-errors
		must.rm ~/.zlogin
		must.rm ~/.zshenv
		must.rm ~/.zshrc
		must.rm ~/.zprofile
		must.rm ~/.zcompdump
		must.rm "${ZDOTDIR-"$HOME"}/.zcompdump"
	fi

	# Fetch GithHub authorization tokens.
	if [ -f ~/.dotfiles/.data/github_token ]; then
		core.print_info 'Already downloaded GitHub token'
	else
		local hostname=$HOSTNAME

		printf '%s\n' "Go to: https://github.com/settings/tokens/new?description=General+@${hostname}&scopes="
		read -erp "Paste token: "

		local token="$REPLY"
		printf '%s\n' "$token" >~/.dotfiles/.data/github_token
	fi

	# Check SSH files.
	{
		if [ ! -d ~/.ssh ]; then
			core.print_die "Expected to find an ~/.ssh directory"
		fi
		must.strict_permissions ~/.ssh/ ~/.ssh/*

		if [ -f ~/.ssh/github ]; then
			core.print_info "Has ssh key \"~/.ssh/github\""
		else
			core.print_die "Does not have ssh key \"~/.ssh/github\""
		fi
	}

	# Check GnuPG files.
	{
		if [ ! -d ~/.gnupg ]; then
			core.print_die "Expected to find an ~/.gnupg directory"
		fi
		must.strict_permissions ~/.gnupg/ ~/.gnupg/*

		if [[ $computer_profile == @(desktop|laptop) ]]; then
			if gpg --list-keys 0x2FB93BF35E14E7C4 &>/dev/null; then
				core.print_info "Has gpg key \"Edwin Kofler (FOR PASSWORDS ONLY) <edwin@kofler.dev>\""
			else
				core.print_info "Does not have gpg key \"Edwin Kofler (FOR PASSWORDS ONLY) <edwin@kofler.dev>\""
			fi
			if gpg --list-keys 0x3851E5FD042C7C6C &>/dev/null; then
				core.print_info "Has gpg key \"Edwin Kofler <edwin@kofler.dev>\""
			else
				core.print_die "Does not have gpg key \"Edwin Kofler <edwin@kofler.dev>\""
			fi
		fi
	}

	# Install the most paramount tools.
	~/scripts/setup/d.sh
	~/scripts/setup/zsh.sh
	~/scripts/setup/ksh.sh
	~/scripts/setup/rust.sh
	~/scripts/setup/mise.sh

	# Install personal tools.
	#~/scripts/setup/npm.sh
	~/scripts/setup/pass.sh
	~/scripts/setup/dev.sh
	# ~/scripts/setup/sauerkraut.sh # TODO
	~/scripts/setup/basalt.sh
	~/scripts/setup/woof.sh

	# Install other important tools.
	~/scripts/setup/flatpak.sh
	# ~/scripts/setup/appimagelauncher.sh # TODO
	~/scripts/setup/notify-send.sh
	~/scripts/setup/cmake.sh
	~/scripts/setup/lefthook.sh
	~/.dotfiles/bake init # Depends on mise and lefthook.
	~/scripts/setup/git.sh

	# Install applications.
	~/scripts/setup/neovim.sh
	~/scripts/setup/firefox.sh
	~/scripts/setup/librewolf.sh
	~/scripts/setup/brave.sh
	~/scripts/setup/maestral.sh
	~/scripts/setup/vscode.sh
	~/scripts/setup/thunderbird.sh
	~/scripts/setup/obsidian.sh
	~/scripts/setup/kitty.sh
	~/scripts/setup/git-diff-so-fancy.sh

	~/scripts/setup/gh.sh
	~/scripts/setup/shfmt.sh
	~/scripts/setup/shellcheck.sh
	~/scripts/setup/bats.sh
	~/scripts/setup/less.sh
	~/scripts/setup/latex.sh
	~/scripts/setup/fish.sh
	~/scripts/setup/miscellaneous.sh
	~/scripts/setup/direnv.sh

	~/scripts/setup/llvm.sh
	~/scripts/setup/bake.sh
	~/scripts/setup/pre-commit.sh
	~/scripts/setup/homebrew.sh
	~/scripts/setup/nerdfonts.sh

	# TODO:
	# ~/scripts/setup/blender.sh
	~/scripts/setup/borg.sh
	~/scripts/setup/darktable.sh
	~/scripts/setup/anki.sh
	~/scripts/setup/sqlitebrowser.sh
	# ~/scripts/setup/virtualbox.sh
	~/scripts/setup/zed.sh
	~/scripts/setup/syncthing.sh
	~/scripts/setup/kdenlive.sh
	~/scripts/setup/bats.sh
	~/scripts/setup/btrfs.sh
	~/scripts/setup/zfs.sh
	~/scripts/setup/yt-dlp.sh

	core.shopt_push -s nullglob
	for file in "$XDG_CONFIG_HOME"/libreoffice/4/user/template/*; do
		local output=
		case $file in
		*.ott)
			core.print_info "Creating instance of template \"${file##*/}\""
			if ! output=$(libreoffice --headless --convert-to odt --outdir ~/Other/Templates "$file"); then
				printf '%s\n' "$output"
			fi
			;;
		*.ots)
			core.print_info "Creating instance of template \"${file##*/}\""
			if ! output=$(libreoffice --headless --convert-to ods --outdir ~/Other/Templates "$file"); then
				printf '%s\n' "$output"
			fi
			;;
		*)
			core.print_info "Skipping template file \"${file##*/}\""
			;;
		esac
		unset -v output
	done
	unset -v file
	core.shopt_pop

	echo 'Done.'
}

must.rm() {
	local file="$1"

	if [ -f "$file" ]; then
		local output=
		if output=$(rm -f -- "$file" 2>&1); then
			core.print_info "Removed file '$file'"
		else
			core.print_warn "Failed to remove file '$file'"
			printf '  -> %s\n' "$output"
		fi
		unset -v output
	fi
}

must.rmdir() {
	local dir="$1"

	if [ -d "$dir" ]; then
		local output=
		if output=$(rmdir -- "$dir" 2>&1); then
			core.print_info "Removed directory '$dir'"
		else
			core.print_warn "Failed to remove directory '$dir'"
			printf '  -> %s\n' "$output"
		fi
		unset -v output
	elif [ -e "$dir" ]; then
		core.print_fatal "Not a directory: \"$dir\""
	fi
}

must.dir() {
	local dir=
	for dir; do
		if [ ! -d "$dir" ]; then
			local output=
			if output=$(mkdir -p -- "$dir" 2>&1); then
				core.print_info "Created directory '$dir'"
			else
				core.print_warn "Failed to create directory '$dir'"
				printf '  -> %s\n' "$output"
			fi
			unset -v output
		fi
	done
	unset -v dir
}

must.file() {
	local file="$1"

	if [ ! -f "$file" ]; then
		local output=
		if output=$(mkdir -p -- "${file%/*}" && touch -- "$file" 2>&1); then
			core.print_info "Created file '$file'"
		else
			core.print_warn "Failed to create file '$file'"
			printf '  -> %s\n' "$output"
		fi
		unset -v output
	fi
}

must.link() {
	local src="$1"
	local target="$2"

	# Skip if symlink is already correct.
	local target_full
	if target_full=$(readlink "$target"); then
		if [ -L "$target" ] && [ "$target_full" = "$src" ]; then
			return
		fi
	fi

	if [ ! -e "$src" ]; then
		core.print_warn "Skipping symlink from '$src' to $target (source directory not found)"
		return
	fi

	# If it is an empty directory and not a symlink, automatically remove it.
	core.shopt_push -s nullglob
	if [ -d "$target" ] && [ ! -L "$target" ]; then
		local children=
		children=("$target"/*)
		if ((${#children[@]} == 0)); then
			rmdir "$target"
		else
			core.print_warn "Skipping symlink from '$src' to '$target' (target a non-empty directory)"
			return
		fi
	fi
	core.shopt_pop

	local output=
	if output=$(ln -sfT "$src" "$target" 2>&1); then
		core.print_info "Symlinking '$src' to $target"
	else
		core.print_warn "Failed to symlink from '$src' to '$target'"
		printf '  -> %s\n' "$output"
	fi
	unset -v output
}

must.unlink() {
	local file="$1"

	if [ -e "$file" ] && [ ! -L "$file" ]; then
		_util_log_warn "Skipping non-symbolic link: \"$file\""
		return
	fi

	local output=
	if output=$(unlink "${file%/}" 2>&1); then
		core.print_info "Unsymlinking \"$file\""
	else
		core.print_warn "Failed to unsymlink \"$file\""
		printf '  -> %s\n' "$output"
	fi
	unset -v output
}

must.user_in_group() {
	local user="$1"
	local group="$2"

	if id -nG "$user" | grep -qw "$group"; then
		return
	fi

	local output=
	if output=$(sudo groupadd "$group" 2>&1); then
		core.print_info "Creating group \"$group\""
	else
		local code=$?
		if ((code != 9)); then
			core.print_warn "Failed to create group \"$group\""
			printf '%s\n' "  -> $output"
		fi
	fi
	unset -v output

	if sudo usermod -aG "$group" "$user"; then
		core.print_info "Added user \"$user\" to group \"$group\""
	else
		core.print_warn "Failed to add user \"$user\" to group \"$group\""
	fi
}

must.strict_permissions() {
	local file= result= badfiles=()
	for file; do
		if [ -d "$file" ]; then
			continue
		fi

		result=$(stat -L -c '%a %G %U' "$file")
		local perms=${result%% *}
		local group=${result#* }
		group=${group% *}
		local user=${result##* }
		local file_pretty=~${file#"$HOME"}
		if [ -d "$file" ]; then
			if [ "$perms" != '700' ]; then
				core.print_warn "Expected permissions of \"600\" instead of \"$perms\" on file \"$file_pretty\""
				badfiles+=("$file")
			fi
		else
			if [ "$perms" != '600' ]; then
				core.print_warn "Expected permissions of \"600\" instead of \"$perms\" on file \"$file_pretty\""
				badfiles+=("$file")
			fi
		fi
		if [ "$user" != "$USER" ]; then
			core.print_warn "Expected ownership of user \"$USER\" instead of \"$group\" on file \"$file_pretty\""
			badfiles+=("$file")
		fi
		if [ "$group" != "$USER" ]; then
			core.print_warn "Expected ownership of group \"$USER\" instead of \"$group\" on file \"$file_pretty\""
			badfiles+=("$file")
		fi
	done

	if ((${#badfiles} > 0)); then
		if util.confirm 'Fix?'; then
			for file in "${badfiles[@]}"; do
				if [ -d "$file" ]; then
					chmod 700 "$file"
					chown "$USER:$USER" "$file"
				else
					chmod 600 "$file"
					chown "$USER:$USER" "$file"
				fi
			done
		fi
	fi
}

dependencies.debian() {
	local packages=()
	packages+=(apt-transport-https build-essential)
	packages+=(bash-completion curl rsync cmake ccache vim nano jq lvm2) # lint-ignore:curl-must-have-args
	packages+=(pkg-config libssl-dev)                                    # For starship

	sudo apt-get -y install "${packages[@]}"
}
dependencies.ubuntu() {
	dependencies.debian "$@"
}
dependencies.fedora() {
	local packages=()
	packages+=(@development-tools)
	packages+=(bash-completion curl rsync cmake ccache vim nano jq lvm2) # lint-ignore:curl-must-have-args
	packages+=(pkg-config openssl-devel)                                 # For starship
	packages+=(dnf-plugins-core)                                         # For at least Brave

	sudo dnf -y install "${packages[@]}"
}
dependencies.opensuse() {
	local packages=()
	packages+=(bash-completion curl rsync cmake ccache vim nano jq lvm2) # lint-ignore:curl-must-have-args
	packages+=(pkg-config openssl-devel)                                 # For starship

	sudo zypper -n install -t pattern devel_basis
	sudo zypper -n install "${packages[@]}"
}
dependencies.arch() {
	local packages=()
	packages+=(base-devl lvm2 openssl yay)

	sudo pacman -Syu --noconfirm "${packages[@]}"
}
installed() {
	:
	# TODO exit code when not installed
	# TODO fix showing Info: File "" has not function "installed"
}

util.if_file_sourced || _main "$@"
