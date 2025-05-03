#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

# TODO: woof, nerdfonts
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

main() {
	local flag_fix=false
	local flag_no_upgrade=false
	for arg; do case $arg in
	--prompt-fix)
		shift
		flag_fix=true ;;
	--no-upgrade)
		shift
		flag_no_upgrade=true ;;
	*)
		core.print_die "Invalid argument: \"$arg\"" ;;
	esac done; unset -v arg

	if [ "$flag_no_upgrade" != 'true' ]; then
		core.print_info 'Upgrading system (pass "--no-upgrade" to skip)...'
		util.update_system
		helper.setup --no-confirm --fn-prefix=dependencies 'Bootstrap' "$@"
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
	done; unset -v file
	core.print_info 'Cleaned shell dotfiles'
	
	# Create necessary directories, files, and groups.
	must.dir "$XDG_CONFIG_HOME"
	must.dir ~/.local/bin
	must.dir ~/.dotfiles/.data/bin
	must.dir ~/.dotfiles/.data/repos
	must.dir ~/.dotfiles/.home
	must.dir ~/.dotfiles/.data
	must.dir "$XDG_STATE_HOME/Android/Sdk"
	must.dir "$XDG_STATE_HOME/history"
	must.dir "$XDG_STATE_HOME/nano/backups"
	must.dir "$XDG_DATA_HOME/maven"
	must.dir "$XDG_DATA_HOME/tig"
	must.dir "$XDG_CONFIG_HOME/sage" # $DOT_SAGE
	must.dir "$XDG_CONFIG_HOME/Code - OSS/User"
	must.dir "$XDG_CONFIG_HOME/spacemacs"
	must.dir "$XDG_DATA_HOME/sonarlint" # $SONARLINT_USER_HOME
	# must.file "$XDG_CONFIG_HOME/yarn/config" # TODO
	must.file "$XDG_STATE_HOME/tig/history"
	must.file "$XDG_STATE_HOME/history/zsh_history" # ZSH's $HISTFILE
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
	must.link ~/.dotfiles/os-unix/scripts ~/scripts

	# Use correct XDG user directories config.
	{
		local profile="$(<~/.dotfiles/.data/profile)"
		if [ "$profile" = 'desktop' ]; then
			local filename='user-dirs-custom.conf'
		else
			local filename='user-dirs-other.conf'
		fi
		if [ -f "$XDG_CONFIG_HOME/user-dirs.dirs" ]; then
			mv "$XDG_CONFIG_HOME/user-dirs.dirs" ~/.bootstrap/distro-dotfiles
		fi
		# Use 'cp -f' for "$XDG_CONFIG_HOME/user-dirs.dirs"; otherwise unlink/link operation fails.
		cp -f "$HOME/.dotfiles/os-unix/config-linux-core/.config/user-dirs.dirs/$filename" "$XDG_CONFIG_HOME/user-dirs.dirs"
		unset -v filename
	}

	# Create and symlink XDG user directories.
	(
		source "$XDG_CONFIG_HOME/user-dirs.dirs"

		for dir in "$XDG_DESKTOP_DIR" "$XDG_DOWNLOAD_DIR" "$XDG_TEMPLATES_DIR" "$XDG_PUBLICSHARE_DIR" "$XDG_DOCUMENTS_DIR" "$XDG_MUSIC_DIR" "$XDG_PICTURES_DIR" "$XDG_VIDEOS_DIR"; do
			if [ -n "$dir" ]; then
				must.dir "$dir"
			fi
		done; unset -v dir

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

	# Last since they're dependent on the previous symlinking.
	must.dir "$HOME/.dotfiles/.home/Documents/AppImages"

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

	# SSH
	{
		if [ ! -d ~/.ssh ]; then
			failure "ssh: Expected to find an ~/.ssh directory"
		fi
		must.strict_directory_permissions 'ssh' ~/.ssh/
		must.strict_file_permissions 'ssh' ~/.ssh/*

		if [ -f ~/.ssh/github ]; then
			success "Has GitHub private SSH key"
		else
			failure "ssh: Expected the file \"~/.ssh/github\" to exist"
			core.print_die 'Exiting...'
		fi
	}

	# GnuPG
	{
		if [ ! -d ~/.gnupg ]; then
			failure "gpg: Expected to find an ~/.gnupg directory"
		fi
		must.strict_directory_permissions 'gpg' ~/.gnupg/
		must.strict_file_permissions 'gpg' ~/.gnupg/*

		if ! gpg --list-public-keys | grep --quiet 'edwin@kofler.dev'; then
			failure "gpg: Expected a gpg key with email \"edwin@kofler.dev\" to exist"
			core.print_die 'Exiting...'
		fi
		if gpg --list-keys 0x2FB93BF35E14E7C4 &>/dev/null; then
			success "gpg: Has password-store gpg public key"
		else
			failure "gpg: Does not have password-store gpg public key"
			core.print_die 'Exiting...'
		fi
		if gpg --list-keys 0x3851E5FD042C7C6C &>/dev/null; then
			success "gpg: Has commit signing gpg public key"
		else
			failure "gpg: Does not have commit signing gpg public key"
			core.print_die 'Exiting...'
		fi
	}

	# Download and install NodeJS runtime.
	local dir=(~/.dotfiles/.data/node-v*/)
	dir=${dir%/}
	if [[ "${dir}" == *\* ]]; then
		dir=
	fi
	local old_nodejs_version="${dir[0]##*/}"
	old_nodejs_version=${old_nodejs_version#node-v}
	old_nodejs_version=${old_nodejs_version%%-*}
	local nodejs_version='23.6.0' # TODO: Update and update docs
	if [ -d "${dir[0]}" ] && [ "$old_nodejs_version" = "$nodejs_version" ]; then
		local dir_nice="~${dir[0]#$HOME}"
		core.print_info "Already installed NodeJS to $dir_nice"
	else
		pushd ~/.dotfiles/.data >/dev/null
		local file="./node-v$nodejs_version.tar.xz"
		if [ "$old_nodejs_version" != "$nodejs_version" ] && [ -n "$old_nodejs_version" ]; then
			core.print_info "Removing outdated NodeJS v$old_nodejs_version"
			rm -rf "${dir[0]}"
		fi
		core.print_info "Downloading NodeJS v$nodejs_version"
		curl -K "$CURL_CONFIG" -o "$file" "https://nodejs.org/dist/v$nodejs_version/node-v$nodejs_version-linux-x64.tar.xz"
		core.print_info "Extracting $file"
		tar xf "$file"
		rm -rf "$file"
		popd >/dev/null
	fi
	if [ ! -f ~/.dotfiles/.data/node ]; then
		ln -sf ~/.dotfiles/.data/node-v*/bin/node ~/.dotfiles/.data/node
	fi

	# Download and install "dev".
	local dir="$HOME/.dev"
	if [ ! -d "$dir" ]; then
		util.clone "$dir" git@github.com:fox-incubating/dev
	fi
	if [ ! -f ~/.dotfiles/.data/bin/dev ]; then
		cd ~/.dotfiles/.data/node*/
		local bin_dir="$PWD"
		bin_dir=${bin_dir#/home/}
		bin_dir=${bin_dir#*/}
		bin_dir="$HOME/$bin_dir/bin"
		PATH="$bin_dir:$PATH"
		cd ~/.dev/
		npm i -g pnpm
		pnpm install

		cat <<-EOF > ~/.dotfiles/.data/bin/dev
		#!/usr/bin/env sh
		set -e
		PATH="$bin_dir:\$PATH" ~/.dev/bin/dev.ts "\$@"
		EOF
		chmod +x ~/.dotfiles/.data/bin/dev
	fi
	mkdir -p "${XDG_DATA_HOME:-$HOME/.local/share}/systemd/user"
	cat > "${XDG_DATA_HOME:-$HOME/.local/share}/systemd/user/dev.service" <<-'EOF'
[Unit]
Description=Dev
ConditionPathIsDirectory=%h/.dev

[Service]
Type=simple
WorkingDirectory=%h/.dev
ExecStart=%h/.dotfiles/.data/node %h/.dev/bin/dev.js start-dev-server
Environment=PORT=40008
Restart=on-failure

[Install]
WantedBy=default.target
EOF
	systemctl --user daemon-reload
	# systemctl --user enable --now dev.service # TODO

	must.setup ~/scripts/setup/d.sh
	must.setup ~/scripts/setup/mise.sh
	must.setup ~/scripts/setup/lefthook.sh
	(
		if ! mise trust --show mise | grep -q '~/.dotfiles: trusted'; then
			mise trust ~/.dotfiles/.mise.toml
		fi
		mise install cmake@latest
		mise use -g cmake@latest
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

	printf '%s\n' "BINARIES:"
	check.command clang-format
	check.command clang-tidy
	check.command bake
	check.command basalt
	check.command ksh
	check.command 'dufs'
	check.command 'pre-commit'
}

success() {
	printf '%s\n' "✅ $1"
}

failure() {
	printf '%s\n' "⛔ $1"
}

# TODO: The whole output thing needs to be improved generally. Use alternative screen?
check.command() {
	local cmd="$1"

	if command -v "$cmd" &>/dev/null; then
		success "Is installed: $cmd"
	else
		failure "Not installed: $cmd"
	fi
}

check.process() {
	local process="$1"

	if pgrep "$process" &>/dev/null; then
		success "$process is running"
	else
		if (($? == 1)); then
			failure "$process not running"
		else
			failure "Syntax or memory error when calling pgrep"
		fi
	fi
}

should_fix() {
	if [ "$flag_fix" = true ] && util.confirm "Would you like to fix this?"; then
		return 0
	else
		return 1
	fi
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

must.strict_directory_permissions() {
	local prefix="$1"
	local dir="$2"

	local result=
	result=$(stat -L -c '%a %G %U' "$dir")

	local perm=${result%% *}
	if [ "$perm" != '700' ]; then
		failure "$prefix: Directory \"$dir\" has incorrect permissions set"
		printf '%s\n' "  -> Expected \"700\" got \"$perm\"" >&2
		if should_fix; then
			chmod 700 "$dir"
		fi
	fi

	local owner=${result##* }
	if [ "$owner" != "$USER" ]; then
		failure "$prefix: Directory \"$dir\" has incorrect owner set"
		printf '%s\n' "  -> Expected \"$USER\" got \"$group\"" >&2
		if should_fix; then
			chown "$USER" "$dir"
		fi
	fi

	local group=${result#* }
	group=${group% *}
	if [ "$group" != "$USER" ]; then
		failure "$prefix: Directory \"$dir\" has incorrect group set"
		printf '%s\n' "  -> Expected \"$USER\" got \"$group\"" >&2
		if should_fix; then
			chown ":$USER" "$dir"
		fi
	fi

}

must.strict_file_permissions() {
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
		if [ "$result" != "600 $USER $USER" ]; then
			failure "$prefix: File \"$file\" has incorrect permission or owner or group set"
			printf '%s\n' "  -> Expected \"600 $USER $USER\" got \"$result\"" >&2
			badfiles+=("$file")
		fi
	done
	if ((${#badfiles} > 0)); then
		if should_fix; then
			chmod 600 "${badfiles[@]}"
			chown "$USER:$USER" "${badfiles[@]}"
		fi
	fi
}

must.setup() {
	local setup_file=$1

	# Use separate subshells in case PATH is modified.
	(
		source "$setup_file"
		if ! command -v installed &>/dev/null; then
			failure "Function not found: \"installed\""
		fi

		if installed; then
			success "Program already installed: \"${setup_file##*/}\""
		else
			failure "Program not installed: \"${setup_file##*/}\""
			if should_fix; then
				helper.setup --no-confirm "$@"
			fi
		fi
	)

	(
		source "$setup_file"
		if ! installed; then
			failure "Attempted to install \"${setup_file##*/}\", but failed (pass \"--prompt-fix\"?)"
			exit 1
		fi
	)
}

dependencies.debian() {
	sudo apt-get -y update && sudo apt-get -y upgrade
	sudo apt-get -y install apt-transport-https build-essential
	sudo apt-get -y install bash-completion curl rsync cmake ccache vim nano jq lvm2 # lint-ignore:curl-must-have-args
	sudo apt-get -y install pkg-config libssl-dev # For starship
}
dependencies.ubuntu() {
	dependencies.debian "$@"
}
dependencies.fedora() {
	sudo dnf -y update
	sudo dnf -y install @development-tools
	sudo dnf -y install bash-completion curl rsync cmake ccache vim nano jq lvm2 # lint-ignore
	sudo dnf -y install pkg-config openssl-devel # For starship
	sudo dnf -y install dnf-plugins-core # For at least Brave
}
dependencies.opensuse() {
	sudo zypper -n update
	sudo zypper -n install -t pattern devel_basis
	sudo zypper -n install bash-completion curl rsync cmake ccache vim nano jq lvm2 # lint-ignore
	sudo zypper -n install pkg-config openssl-devel # For starship
}
dependencies.arch() {
	sudo pacman -Syyu --noconfirm
	sudo pacman -Syu --noconfirm base-devl lvm2 openssl yay
}

util.if_file_sourced || helper.run_main "$@"
