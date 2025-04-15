#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

# TODO: woof, nerdfonts
# TODO: git smuge etc filters are in use
# if command -v autoenv_init >/dev/null 2>&1; then
# 		autoenv_init || :
# 	else
# 		_shell_util_log_warn "cd: Function is not defined: autoenv_init"
# 	fi

# 	if command -v __woof_cd_hook >/dev/null 2>&1; then
# 		__woof_cd_hook || :
# 	else
# 		_shell_util_log_warn "cd: Function is not defined: __woof_cd_hook"
# 	fi

main() {
	local flag_fix=false
	local flag_no_upgrade=false
	for arg; do case $arg in
	--prompt-to-fix)
		flag_fix=true ;;
	--no-upgrade)
		flag_no_upgrade=true ;;
	esac done; unset -v arg

	if [ "$flag_no_upgrade" != 'true' ]; then
		core.print_info 'Upgrading system (pass "--no-upgrade" to skip)...'
		util.update_system
		helper.setup --no-confirm --fn-prefix=install_packages 'Bootstrap' "$@"
	fi

	mkdir -p "$XDG_CONFIG_HOME"

	# Remove distribution-specific dotfiles.
	mkdir -p ~/.bootstrap/distro-dots
	for file in ~/.bash_login ~/.bash_logout ~/.bash_profile ~/.bashrc ~/.profile; do
		if [[ ! -L "$file" && -f "$file" ]]; then
			mv "$file" ~/.bootstrap/distro-dots
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

	# Download and install NodeJS runtime.
	local dir=(~/.dotfiles/.data/node-v*/)
	dir=${dir%/}
	if [[ "${dir}" == *\* ]]; then
		dir=
	fi
	local old_nodejs_version="${dir[0]##*/}"
	old_nodejs_version=${old_nodejs_version#node-v}
	old_nodejs_version=${old_nodejs_version%%-*}
	local nodejs_version='23.6.0' # TODO: Update
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

		mkdir -p ~/.dotfiles/.data/bin
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
		check_dir_permissions 'ssh' ~/.ssh/
		check_file_permissions 'ssh' ~/.ssh/*

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
		check_dir_permissions 'gpg' ~/.gnupg/
		check_file_permissions 'gpg' ~/.gnupg/*

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

	# d
	{
		mkdir -p ~/.dotfiles/.data/repos
		local dir="$HOME/.dotfiles/.data/repos/d"
		if [ ! -d "$dir" ]; then
			util.clone "$dir" git@github.com:fox-incubating/d
		fi
		cd ~/.dotfiles/.data/repos/d
		./bake build "\"$HOME/.dotfiles/os-unix/data\""
		ln -fs "$PWD/d" ~/.local/bin/d
	}

	install_from_setup ~/scripts/setup/bats.sh
	install_from_setup ~/scripts/setup/mise.sh
	install_from_setup ~/scripts/setup/git.sh # TODO: 'spaceman-diff'
	install_from_setup ~/scripts/setup/neovim.sh
	install_from_setup ~/scripts/setup/pass.sh
	install_from_setup ~/scripts/setup/app/firefox.sh
	install_from_setup ~/scripts/setup/app/brave.sh
	install_from_setup ~/scripts/setup/app/maestral.sh
	install_from_setup ~/scripts/setup/gh.sh

	printf '%s\n' "BINARIES:"
	check.command clang-format
	check.command clang-tidy
	check.command bake
	check.command basalt
	check.command ksh
	printf '\n'

	printf '%s\n' "BINARIES: DEVELOPMENT:"
	check.command 'dufs'
	check.command 'pre-commit'
	printf '\n'

	printf '%s\n' "LATEX:"
	check.command latexindent
	printf '\n'

	printf '%s\n' "FISH:"
	check.command fish
	check.command fish-indent
	printf '\n'

	printf '%s\n' "SENSITIVE:"
	if [ -d "$XDG_DATA_HOME/password-store" ]; then
		if [ -d "$XDG_DATA_HOME/password-store" ]; then
			success "Has password-store and is git directory"
		else
			failure "Password-store not a git directory"
		fi
	else
		failure "Password-store not found in the correct location"
	fi
}

success() {
	printf '%s\n' "✅ $1"
}

failure() {
	printf '%s\n' "⛔ $1"
}

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

check_dir_permissions() {
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

check_file_permissions() {
	local prefix="$1"
	if ! shift; then
		core.print_die 'Failed to shift'
	fi

	local file= result= badfiles=()
	for file; do
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

install_from_setup() {
	local setup_file=$1
	(
		source "$setup_file"
		if ! command -v installed &>/dev/null; then
			:
		fi

		if installed; then
			success "Program already installed: \"${setup_file##*/}\""
		else
			# Version must be at least 2.37.0 to support "push.autoSetupRemote".
			failure "Program not installed: \"${setup_file##*/}\""
			if should_fix; then
				install
			fi
		fi
	)

	# Separate subshell in case PATH was modified etc.
	(
		source "$setup_file"
		if ! installed; then
			failure "Attempted to install \"${setup_file##*/}\", but failed"
			exit 1
		fi
	)
}

install_packages.arch() {
	sudo pacman -Syyu --noconfirm
	sudo pacman -Syu --noconfirm base-devl lvm2 openssl yay
}

install_packages.debian() {
	sudo apt-get -y update && sudo apt-get -y upgrade
	sudo apt-get -y install apt-transport-https build-essential
	sudo apt-get -y install bash-completion curl rsync cmake ccache vim nano jq lvm2 # lint-ignore:curl-must-have-args
	sudo apt-get -y install pkg-config libssl-dev # For starship
}

install_packages.fedora() {
	sudo dnf -y update
	sudo dnf -y install @development-tools
	sudo dnf -y install bash-completion curl rsync cmake ccache vim nano jq lvm2 # lint-ignore
	sudo dnf -y install pkg-config openssl-devel # For starship
	sudo dnf -y install dnf-plugins-core # For at least Brave
}

install_packages.opensuse() {
	sudo zypper -n update
	sudo zypper -n install -t pattern devel_basis
	sudo zypper -n install bash-completion curl rsync cmake ccache vim nano jq lvm2 # lint-ignore
	sudo zypper -n install pkg-config openssl-devel # For starship
}

util.if_file_sourced || main "$@"
