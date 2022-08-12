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

	mkdir -p ~/.bootstrap

	# Install essential commands
	case $(uname) in darwin*)
		if iscmd 'brew'; then
			log "Already installed brew"
		else
			log 'Installing brew'
			curl -fsSLo ~/.bootstrap/install-brew.sh 'https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh'
			bash ~/.bootstrap/install-brew.sh
		fi
	esac
	installcmd 'git' 'git'
	installcmd 'nvim' 'neovim'

	# Install hyperupcall/dots
	clonerepo 'github.com/hyperupcall/dots' ~/.dots
	run cd ~/.dots
		run git remote set-url origin 'git@github.com:hyperupcall/dots'
		run ./bake init
	run cd ~

	# Install hyperupcall/dotmgr
	clonerepo 'github.com/hyperupcall/dotmgr' ~/.dots/.dotmgr
	run cd ~/.dots/.dotmgr
		run git remote set-url origin 'git@github.com:hyperupcall/dotmgr'
	run cd ~
	run printf '%s\n' '~/.dots/dotmgr' > ~/.dots/.dotmgr/.dotmgr_dir
	run mkdir -p ~/.dots/.usr/bin
	run ln -sf ~/.dots/.dotmgr/bin/dotmgr ~/.dots/.usr/bin/dotmgr

	# Asserts
	if [ ! -f ~/.dots/xdg.sh ]; then
		die 'Failed to find file at ~/.dots/xdg.sh'
	fi

	# Export variables
	cat > ~/.bootstrap/bootstrap-out.sh <<EOF
# shellcheck shell=sh

export NAME='Edwin Kofler'
export EMAIL='edwin@kofler.dev'
export EDITOR='nvim'
export VISUAL="\$EDITOR"
export PATH="\$HOME/.dots/.usr/bin:\$PATH"

if [ -f ~/.dots/xdg.sh ]; then
	. ~/.dots/xdg.sh
else
	printf '%s\n' 'Error: ~/.dots/xdg.sh not found'
	return 1
fi
EOF

	# Next steps
	cat <<-"EOF"
	---
	. ~/.bootstrap/bootstrap-out.sh
	dotmgr bootstrap
	---
	EOF
}

# -------------------------------------------------------- #
#                         FUNCTIONS                        #
# -------------------------------------------------------- #

# TODO: REMOVE
if [ -t 0 ]; then
	GLOBAL_FMT_BLACK_FG='\033[1;30m'
	GLOBAL_FMT_WHITE_BG='\033[1;47m'
	GLOBAL_FMT_RESET='\033[0;0m'
	GLOBAL_FMT_START="$GLOBAL_FMT_WHITE_BG$GLOBAL_FMT_BLACK_FG"
	GLOBAL_FMT_END="$GLOBAL_FMT_RESET"
else
	GLOBAL_FMT_START=
	GLOBAL_FMT_END=
fi

die() {
	error "$@"
	printf "$GLOBAL_FMT_START%s$GLOBAL_FMT_END Exiting\n" '=>' >&2
	exit 1
}

error() {
	printf "$GLOBAL_FMT_START%s$GLOBAL_FMT_END Error: %s\n" '=>' "$1" >&2
}

log() {
	printf "$GLOBAL_FMT_START%s$GLOBAL_FMT_END Info: %s\n" '=>' "$1" >&2
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
