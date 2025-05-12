#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

main() {
	for arg; do case $arg in
	*)
		core.print_die "Invalid argument: \"$arg\"" ;;
	esac done; unset -v arg

	# Install required dependencies.
	if [ ! -f ~/.dotfiles/.data/finished_bootstrap ]; then
		install_required_dependencies
		touch ~/.dotfiles/.data/finished_bootstrap
		core.print_info "Installed required dependencies"
	fi

	# Remove broken symlinks.
	for f in "$HOME"/*; do
		if [ -L "$f" ] && [ ! -e "$f" ]; then
			unlink "$f"
		fi
	done

	# Remove autoappended lines in shell startup files.
	for file in ~/.profile ~/.bashrc ~/.bash_profile "${ZDOTDIR:-$HOME}/.zshrc" "${ZDOTDIR:-$HOME}/.zshenv" "$XDG_CONFIG_HOME/fish/config.fish"; do
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
		unset -v file_string
	done; unset -v file
	core.print_info 'Cleaned shell dotfiles'

	# Create necessary symlinks.
	must.link ~/.dotfiles/os-unix/scripts ~/scripts
	for f in ~/.dotfiles/os-unix/bin/*; do
		ln -sf "$f" ~/.local/bin
	done; unset -v f

	# Set XDG user directories.
	{
		xdg-user-dirs-update --set DESKTOP ~/Other/Desktop
		xdg-user-dirs-update --set DOWNLOAD ~/Downloads
		xdg-user-dirs-update --set TEMPLATES ~/Other/Templates
		xdg-user-dirs-update --set PUBLICSHARE ~/Other/Public
		xdg-user-dirs-update --set DOCUMENTS ~/Documents
		xdg-user-dirs-update --set MUSIC ~/Music
		xdg-user-dirs-update --set PICTURES ~/Pictures
		xdg-user-dirs-update --set VIDEOS ~/Videos
	}

	# Symlink XDG base and user directories.
	(
		source "$XDG_CONFIG_HOME/user-dirs.dirs"

		must.link "$XDG_DESKTOP_DIR" "$HOME/.dotfiles/.home/Desktop"
		must.link "$XDG_DOWNLOAD_DIR" "$HOME/.dotfiles/.home/Downloads"
		must.link "$XDG_TEMPLATES_DIR" "$HOME/.dotfiles/.home/Templates"
		must.link "$XDG_PUBLICSHARE_DIR" "$HOME/.dotfiles/.home/Public"
		must.link "$XDG_DOCUMENTS_DIR" "$HOME/.dotfiles/.home/Documents"
		must.link "$XDG_MUSIC_DIR" "$HOME/.dotfiles/.home/Music"
		must.link "$XDG_PICTURES_DIR" "$HOME/.dotfiles/.home/Pictures"
		must.link "$XDG_VIDEOS_DIR" "$HOME/.dotfiles/.home/Videos"

		must.link "$XDG_CACHE_HOME" "$HOME/.dotfiles/.home/xdg_cache_dir"
		must.link "$XDG_CONFIG_HOME" "$HOME/.dotfiles/.home/xdg_config_dir"
		must.link "$XDG_STATE_HOME" "$HOME/.dotfiles/.home/xdg_state_dir"
		must.link "$XDG_DATA_HOME" "$HOME/.dotfiles/.home/xdg_data_dir"

		for f in "$HOME/.dotfiles/.home"/*; do
			if [ -L "$f" ] && [ ! -e "$f" ]; then
				unlink "$f"
			fi
		done; unset -v f
	)

	# Create necessary directories, files, and groups.
	must.dir ~/.dotfiles/.data/bin
	must.dir ~/.dotfiles/.data/repos
	must.dir ~/.dotfiles/.home
	must.dir ~/.dotfiles/.data
	must.dir ~/.local/bin
	must.dir "$XDG_CONFIG_HOME"
	must.dir "$XDG_DATA_HOME"
	must.dir "$XDG_STATE_HOME"
	must.dir "$XDG_CACHE_HOME"
	must.dir "$XDG_STATE_HOME/Android/Sdk"
	must.dir "$XDG_STATE_HOME/history"
	must.dir "$XDG_STATE_HOME/nano/backups"
	must.dir "$XDG_DATA_HOME/maven"
	must.dir "$XDG_DATA_HOME/tig"
	must.dir "$XDG_CONFIG_HOME/sage" # For $DOT_SAGE.
	must.dir "$XDG_CONFIG_HOME/Code - OSS/User"
	must.dir "$XDG_CONFIG_HOME/spacemacs"
	must.dir "$XDG_DATA_HOME/sonarlint" # For $SONARLINT_USER_HOME.
	must.dir "$HOME/.dotfiles/.home/Documents/AppImages"
	must.file "$XDG_STATE_HOME/tig/history"
	must.file "$XDG_STATE_HOME/history/zsh_history" For # For ZSH $HISTFILE.
	must.user_in_group "$USER" 'docker'
	must.user_in_group "$USER" 'vboxusers'
	must.user_in_group "$USER" 'libvirt'
	must.user_in_group "$USER" 'kvm'
	must.user_in_group "$USER" 'input'

	# Remove default dotfiles. These are customized with environment variables.
	must.rm ~/.bash_history
	must.rm ~/.flutter
	must.rm ~/.flutter_tool_state
	must.rm ~/.gitconfig
	must.rm ~/.gmrun_history
	must.rm ~/.inputrc
	must.rm ~/.lesshst
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

	# Remove distribution-specific dotfiles.
	mkdir -p ~/.bootstrap/distro-dotfiles
	for file in ~/.bash_login ~/.bash_logout ~/.bash_profile ~/.bashrc ~/.profile .dir_colors .dircolors; do
		if [[ ! -L "$file" && -f "$file" ]]; then
			mv "$file" ~/.bootstrap/distro-dotfiles
		fi
	done

	# Set current system profile.
	if [ -f ~/.dotfiles/.data/profile ]; then
		core.print_info 'Already set system profile'
	else
		local cur=
		local options='desktop|laptop'
		while [[ $cur != @($options) ]]; do
			printf '%s' "System profile? ($options): "
			read -er cur
		done
		mkdir -p ~/.dotfiles/.data
		printf '%s\n' "$cur" > ~/.dotfiles/.data/profile
	fi

	# Fetch GithHub authorization tokens.
	if [ -f ~/.dotfiles/.data/github_token ]; then
		core.print_info 'Already downloaded GitHub token'
	else
		local hostname=$HOSTNAME

		printf '%s\n' "Go to: https://github.com/settings/tokens/new?description=General+@${hostname}&scopes="
		read -erp "Paste token: "

		local token="$REPLY"
		printf '%s\n' "$token" > ~/.dotfiles/.data/github_token
	fi

	# Check permissions for SSH files
	{
		if [ ! -d ~/.ssh ]; then
			core.print_die "ssh: Expected to find an ~/.ssh directory"
		fi
		must.strict_permissions 'ssh' ~/.ssh/ ~/.ssh/*

		if [ -f ~/.ssh/github ]; then
			core.print_info "ssh: Has key \"~/.ssh/github\""
		else
			core.print_die "ssh: Does not have key \"~/.ssh/github\""
		fi
	}

	# Check permissions for GnuPG files
	{
		if [ ! -d ~/.gnupg ]; then
			core.print_die "gpg: Expected to find an ~/.gnupg directory"
		fi
		must.strict_permissions 'gpg' ~/.gnupg/ ~/.gnupg/*

		if gpg --list-keys 0x2FB93BF35E14E7C4 &>/dev/null; then
			core.print_info "gpg: Has key \"Edwin Kofler (FOR PASSWORDS ONLY) <edwin@kofler.dev>\""
		else
			core.print_info "gpg: Does not have key \"Edwin Kofler (FOR PASSWORDS ONLY) <edwin@kofler.dev>\""
		fi
		if gpg --list-keys 0x3851E5FD042C7C6C &>/dev/null; then
			core.print_info "gpg: Has key \"Edwin Kofler <edwin@kofler.dev>\""
		else
			core.print_die "gpg: Does not have key \"Edwin Kofler <edwin@kofler.dev>\""
		fi
	}

	must.setup ~/scripts/setup/app/dev.sh
	must.setup ~/scripts/setup/d.sh
	must.setup ~/scripts/setup/mise.sh
	must.setup ~/scripts/setup/lefthook.sh
	(
		if ! mise trust --show mise | grep -q '~/.dotfiles: trusted'; then
			mise trust ~/.dotfiles/.mise.toml
		fi
		mise install cmake@latest
		mise use -g cmake@latest # TODO: not latest, move somewhere else
		cd ~/.dotfiles
		if [ ! -f ./.git/info/lefthook.checksum ]; then
			lefthook install
		fi
	)
	must.setup ~/scripts/setup/git.sh # TODO: 'spaceman-diff'
	must.setup ~/scripts/setup/neovim.sh
	must.setup ~/scripts/setup/pass.sh

	must.setup ~/scripts/setup/app/firefox.sh
	must.setup ~/scripts/setup/app/brave.sh
	must.setup ~/scripts/setup/app/maestral.sh
	must.setup ~/scripts/setup/app/vscode.sh
	must.setup ~/scripts/setup/app/thunderbird.sh

	must.setup ~/scripts/setup/gh.sh
	must.setup ~/scripts/setup/bats.sh
	must.setup ~/scripts/setup/less.sh
	must.setup ~/scripts/setup/latex.sh
	must.setup ~/scripts/setup/fish.sh
	must.setup ~/scripts/setup/my-tools.sh
	~/.dotfiles/os-unix/scripts/lib/util-generate-aliases.sh

	~/scripts/setup/llvm.sh
	~/scripts/setup/zsh.sh
	~/scripts/setup/ksh.sh
	~/scripts/setup/basalt.sh

	# TODO: bake, pre-commit
	# TODO: woof, nerdfonts, notify-send
	# TODO: git smuge etc filters are in use
	# if command -v autoenv_init >/dev/null 2>&1; then
	# 		autoenv_init || :
	# 	else
	# 		_util_log_warn "cd: Function is not defined: autoenv_init"
	# 	fi

	# 	if command -v __woof_cd_hook >/dev/null 2>&1; then
	# 		__woof_cd_hook || :
	# 	else
	# 		_util_log_warn "cd: Function is not defined: __woof_cd_hook"
	# 	fi
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
	elif [ -e "$dir" ]; then
		core.print_fatal "Not a directory: \"$dir\""
	fi
}

must.dir() {
	local d=
	for d; do
		local dir="$d"

		if [ ! -d "$dir" ]; then
			local output=
			if output=$(mkdir -p -- "$dir" 2>&1); then
				core.print_info "Created directory '$dir'"
			else
				core.print_warn "Failed to create directory '$dir'"
				printf '  -> %s\n' "$output"
			fi
		fi
	done; unset -v d
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
	fi
}

must.link() {
	local src="$1"
	local target="$2"

	# Skip if symlink is already correct.
	if [ -L "$target" ] && [ "$(readlink "$target")" = "$src" ]; then
		return
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
		if (( ${#children[@]} == 0)); then
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

	if sudo usermod -aG "$group" "$user"; then
		core.print_info "Added user \"$user\" to group \"$group\""
	else
		core.print_warn "Failed to add user \"$user\" to group \"$group\""
	fi
}

must.strict_permissions() {
	local prefix="$1"
	if ! shift; then
		core.print_die 'Failed to shift'
	fi

	local file= result= badfiles=()
	for file; do
		if [ -d "$file" ]; then
			continue
		fi

		result=$(stat -L -c '%a %G %U' "$file")
		local perms=${result%% *}
		local group=${result#* }; group=${group% *}
		local user=${result##* }
		local file_pretty=~${file#$HOME}
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
		if util.ask_fix; then
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

must.setup() {
	local setup_file=$1

	# Use separate subshells in case PATH is modified.
	(
		source "$setup_file"
		if ! declare -f installed &>/dev/null; then
			core.print_die "Expected file \"$setup_file\" to have function \"installed\""
		fi

		if installed; then
			core.print_info "Already installed \"${setup_file##*/}\""
		else
			core.print_warn "Not installed \"${setup_file##*/}\""
			if util.ask_fix; then
				helper.run_main "$@" # lint-ignore:scripts-must-have-source-guard
			fi
		fi
	)

	(
		source "$setup_file"
		if ! installed; then
			core.print_die "Attempted to install \"${setup_file##*/}\", but failed"
		fi
	)
}

install_required_dependencies() {
	dependencies.debian() {
		local packages=()
		packages+=(apt-transport-https build-essential)
		packages+=(bash-completion curl rsync cmake ccache vim nano jq lvm2) # lint-ignore:curl-must-have-args
		packages+=(pkg-config libssl-dev) # For starship

		sudo apt-get -y install "${packages[@]}"
	}
	dependencies.ubuntu() {
		dependencies.debian "$@"
	}
	dependencies.fedora() {
		local packages=()
		packages+=(@development-tools)
		packages+=(bash-completion curl rsync cmake ccache vim nano jq lvm2) # lint-ignore:curl-must-have-args
		packages+=(pkg-config openssl-devel) # For starship
		packages+=(dnf-plugins-core) # For at least Brave

		sudo dnf -y install "${packages[@]}"
	}
	dependencies.opensuse() {
		local packages=()
		packages+=(bash-completion curl rsync cmake ccache vim nano jq lvm2) # lint-ignore:curl-must-have-args
		packages+=(pkg-config openssl-devel) # For starship

		sudo zypper -n install -t pattern devel_basis
		sudo zypper -n install "${packages[@]}"
	}
	dependencies.arch() {
		local packages=()
		packages+=(base-devl lvm2 openssl yay)

		sudo pacman -Syu --noconfirm "${packages[@]}"
	}

	util.update_system
	helper.setup --no-confirm --fn-prefix=dependencies 'Bootstrap' "$@"
}

util.if_file_sourced || helper.run_main "$@"
