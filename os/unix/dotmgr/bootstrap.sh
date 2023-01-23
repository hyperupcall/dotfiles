#!/usr/bin/env sh
set -e

# shellcheck disable=SC3028,SC3054
if [ -n "$BASH" ] && [ "${BASH_SOURCE[0]}" != "$0" ]; then
	printf '%s\n' "Error: This file should not be sourced"
	return 1
fi

main() {
	if ! iscmd 'sudo'; then
		die "Please install 'sudo' before running this script"
	fi

	run mkdir -p ~/.bootstrap

	# Install essential commands
	installupdates
	case $(uname) in darwin*)
		if iscmd 'brew'; then
			log "Already installed Homebrew"
		else
			log 'Installing Homebrew'
			run curl -fsSLo ~/.bootstrap/install-brew.sh 'https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh'
			bash ~/.bootstrap/install-brew.sh
		fi
	esac
	installcmd 'git' 'git'
	installcmd 'nvim' 'neovim'

	# Install Cargo, Rust
	if [ -d ~/.cargo ]; then
		log 'Already installed Cargo'
	else
		log 'Installing Cargo'
		curl -fsSL 'https://sh.rustup.rs' | sh -s -- --default-toolchain nightly -y
	fi
	. ~/.cargo/env

	# Install hyperupcall/dotfiles
	clonerepo 'github.com/hyperupcall/dotfiles' ~/.dotfiles
	run cd ~/.dotfiles
		run git remote set-url origin 'git@github.com:hyperupcall/dotfiles'
		run ./bake init
	run cd

	# Install hyperupcall/dotmgr
	clonerepo 'github.com/hyperupcall/dotmgr' ~/.dotfiles/.data/dotmgr-src
	run cd ~/.dotfiles/.data/dotmgr-src
		run git remote set-url origin 'git@github.com:hyperupcall/dotmgr'
		run cargo build
	run cd
	run mkdir -p ~/.dotfiles/.data/bin
	run ln -sf ~/.dotfiles/.data/dotmgr-src/target/debug/dotmgr ~/.dotfiles/.data/bin/dotmgr

	# Asserts
	if [ ! -f ~/.dotfiles/xdg.sh ]; then
		die 'Failed to find file at ~/.dotfiles/xdg.sh'
	fi

	# Export variables
	cat > ~/.bootstrap/bootstrap-out.sh <<EOF
# shellcheck shell=sh

export NAME='Edwin Kofler'
export EMAIL='edwin@kofler.dev'
export EDITOR='nvim'
export VISUAL="\$EDITOR"
export PATH="\$HOME/.dotfiles/.data/bin:\$PATH"

if [ -f ~/.dotfiles/xdg.sh ]; then
	. ~/.dotfiles/xdg.sh
else
	printf '%s\n' 'Error: ~/.dotfiles/xdg.sh not found'
	return 1
fi
EOF

	# Next steps
	cat <<-"EOF"
	---
	. ~/.bootstrap/bootstrap-out.sh
	dotmgr script run bootstrap
	---
	EOF
}

# -------------------------------------------------------- #
#                         FUNCTIONS                        #
# -------------------------------------------------------- #

die() {
	error "$@"
	printf "=> Exiting\n" >&2
	exit 1
}

error() {
	printf "=> Error: %s\n" "$1" >&2
}

log() {
	printf "=> Info: %s\n" "$1"
}

run() {
	if "$@"; then :; else
		error "Failed to run command (code $?)"
		printf '%s\n' "  -> Command: $*" >&2
		exit 1
	fi
}

iscmd() {
	if command -v "$1" >/dev/null 2>&1; then
		return $?
	else
		return $?
	fi
}

installupdates() {
	if iscmd 'pacman'; then
		sudo pacman -Syyu --noconfirm
	elif iscmd 'apt-get'; then
		sudo apt-get -y update
		sudo apt-get -y upgrade
		sudo apt-get -y install apt-transport-https
	elif iscmd 'dnf'; then
		sudo dnf -y update
	elif iscmd 'zypper'; then
		sudo zypper -y update
		sudo zypper -y upgrade
	else
		die 'Failed to determine package manager'
	fi
}

installcmd() {
	if iscmd "$1"; then
		log "Already installed $1"
	else
		log "Installing $1"

		if iscmd 'pacman'; then
			run sudo pacman -S --noconfirm "$2"
		elif iscmd 'apt-get'; then
			run sudo apt-get -y install "$2"
		elif iscmd 'dnf'; then
			run sudo dnf -y install "$2"
		elif iscmd 'zypper'; then
			run sudo zypper -y install "$2"
		elif iscmd 'eopkg'; then
			run sudo eopkg -y install "$2"
		elif iscmd 'brew'; then
			run brew install "$2"
		else
			die 'Failed to determine package manager'
		fi

		if ! iscmd "$1"; then
			die "Automatic installation of $1 failed"
		fi
	fi
}

clonerepo() {
	if [ -d "$2" ]; then
		log "Already cloned $1"
	else
		log "Cloning $1"
		run git clone --quiet "https://$1" "$2"
	fi
}

# -------------------------------------------------------- #
#                           START                          #
# -------------------------------------------------------- #

main "$@"
