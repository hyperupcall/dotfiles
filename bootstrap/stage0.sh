#!/usr/bin/env bash
set -e

die() {
	printf '%s\n' "Error: $*. Exiting"
	exit 1
}

ensure() {
	if ! "$@"; then
		die "'$*' failed"
	fi
}

if [ -n "$BASH" ] && [ "${BASH_SOURCE[0]}" != "$0" ]; then
	printf '%s\n' "Error: File 'stage0.sh' should not be sourced"
	exit 1
fi

# Ensure prerequisites
mkdir -p ~/.bootstrap

if ! command -v sudo >/dev/null 2>&1; then
	die "Sudo not installed"
fi

if ! command -v git >/dev/null 2>&1; then
	printf '%s\n' 'Installing git'

	if command -v pacman >/dev/null 2>&1; then
		ensure sudo pacman -S --noconfirm git >/dev/null 2>&1
	elif command -v apt-get >/dev/null 2>&1; then
		ensure sudo apt-get -y install git >/dev/null 2>&1
	elif command -v dnf >/dev/null 2>&1; then
		ensure sudo dnf -y install git >/dev/null 2>&1
	elif command -v zypper >/dev/null 2>&1; then
		ensure sudo zypper -y install git >/dev/null 2>&1
	fi

	if ! command -v git >/dev/null 2>&1; then
		die 'Automatic installation of sudo failed'
	fi
fi

if ! command -v nvim >/dev/null 2>&1; then
	printf '%s\n' 'Installing neovim'

	if command -v pacman >/dev/null 2>&1; then
		ensure sudo pacman -S --noconfirm neovim >/dev/null 2>&1
	elif command -v apt-get >/dev/null 2>&1; then
		ensure sudo apt-get -y install neovim >/dev/null 2>&1
	elif command -v dnf >/dev/null 2>&1; then
		ensure sudo dnf -y install neovim >/dev/null 2>&1
	elif command -v zypper >/dev/null 2>&1; then
		ensure sudo zypper -y install neovim >/dev/null 2>&1
	fi

	if ! command -v nvim >/dev/null 2>&1; then
		die 'Automatic installation of neovim failed'
	fi
fi

if ! command -v jq >/dev/null 2>&1; then
	printf '%s\n' 'Installing jq'

	if command -v pacman >/dev/null 2>&1; then
		ensure sudo pacman -S --noconfirm jq >/dev/null 2>&1
	elif command -v apt-get >/dev/null 2>&1; then
		ensure sudo apt-get -y install jq >/dev/null 2>&1
	elif command -v dnf >/dev/null 2>&1; then
		ensure sudo dnf -y install jq >/dev/null 2>&1
	elif command -v zypper >/dev/null 2>&1; then
		ensure sudo zypper -y install jq >/dev/null 2>&1
	fi

	if ! command -v jq >/dev/null 2>&1; then
		die 'Automatic installation of jq failed'
	fi
fi

# Install ~/.dots
if [ ! -d ~/.dots ]; then
	printf '%s\n' 'Cloning github.com/hyperupcall/dots'

	ensure git clone --quiet https://github.com/hyperupcall/dots ~/.dots
	ensure cd ~/.dots
	ensure git config --local filter.npmrc-clean.clean "$(pwd)/user/config/npm/npmrc-clean.sh"
	ensure git config --local filter.slack-term-config-clean.clean "$(pwd)/user/config/slack-term/slack-term-config-clean.sh"
	ensure git config --local filter.oscrc-clean.clean "$(pwd)/user/config/osc/oscrc-clean.sh"
	ensure cd
fi


# Set EDITOR so editors like 'vi' or 'vim' that may not be installed
# are never executed
if [ -z "$EDITOR" ]; then
	if command -v nvim >/dev/null 2>&1; then
		EDITOR='nvim'
	elif command -v vim >/dev/null 2>&1; then
		EDITOR='vim'
	elif command -v nano >/dev/null 2>&1; then
		EDITOR='nano'
	elif command -v vi >/dev/null 2>&1; then
		EDITOR='vi'
	else
		die "Variable EDITOR cannot be set. Is nvim installed?"
	fi
fi

if [ ! -f ~/.dots/xdg.sh ]; then
	die '~/.dots/xdg.sh not found'
fi

# Export variables for 'bootstrap.sh'
cat > ~/.bootstrap/stage1.sh <<-EOF
# shellcheck shell=sh

export NAME="Edwin Kofler"
export EMAIL="edwin@kofler.dev"
export EDITOR="$EDITOR"
export VISUAL="\$EDITOR"
export PATH="\$HOME/.dots/bootstrap/dotmgr/bin:\$PATH"

if [ -f ~/.dots/xdg.sh ]; then
  . ~/.dots/xdg.sh
else
  printf '%s\n' 'Error: ~/.dots/xdg.sh not found'
  exit 1
fi
EOF

cat <<-"EOF"
---
. ~/.bootstrap/stage1.sh
dotmgr bootstrap-stage1
---
EOF
