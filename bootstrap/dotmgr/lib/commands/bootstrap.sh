# shellcheck shell=bash

if [ -z "$XDG_CONFIG_HOME" ]; then
	die '$XDG_CONFIG_HOME is empty. Did you source profile-pre-bootstrap.sh?'
fi

if [ -z "$XDG_DATA_HOME" ]; then
	die '$XDG_DATA_HOME is empty. Did you source profile-pre-bootstrap.sh?'
fi

# Ensure prerequisites
mkdir -p ~/.bootstrap/{bin,nim-all,old-dots} "$XDG_CONFIG_HOME"
for cmd in git curl; do
	if ! command -v "$cmd" >/dev/null 2>&1; then
		die "$cmd not installed"
	fi
done

# Remove distribution specific dotfiles, including
for file in ~/.bash_login ~/.bash_logout ~/.bash_profile ~/.bashrc ~/.profile; do
	if [ -f "$file" ]; then
		ensure mv "$file" ~/.bootstrap/old-dots
	fi
done

# Download Nim (in case dotfox doesn't work, it may need to be recompiled)
if [ ! -d ~/.bootstrap/nim-all/nim ]; then
	log_info 'Downloading Nim'
	ensure curl -LSso ~/.bootstrap/nim-all/nim-1.4.8-linux_x64.tar.xz https://nim-lang.org/download/nim-1.4.8-linux_x64.tar.xz
	ensure rm -rf ~/.bootstrap/nim-all/nim-1.4.8
	ensure cd ~/.bootstrap/nim-all
	ensure tar xf nim-1.4.8-linux_x64.tar.xz
	ensure cd
	ensure ln -sTf ~/.bootstrap/nim-all/nim-1.4.8 ~/.bootstrap/nim-all/nim
fi

if [ ! -d ~/.bootstrap/dotfox ]; then
	log_info 'Cloning github.com/hyperupcall/dotfox'
	ensure git clone --quiet https://github.com/hyperupcall/dotfox ~/.bootstrap/dotfox
fi

# Download Dotfox
if [ ! -f ~/.bootstrap/bin/dotfox ]; then
	log_info 'Downloading Dotfox'
	if ! dotfox_download_url="$(
		curl -LfSs https://api.github.com/repos/hyperupcall/dotfox/releases/latest \
			| jq -r '.assets[0].browser_download_url'
	)"; then
		die "Could not fetch the dotfox download URL"
	fi
	ensure curl -LsSo ~/.bootstrap/bin/dotfox "$dotfox_download_url"
	ensure chmod +x ~/.bootstrap/bin/dotfox
fi

# Install Homebrew
if [ "$OSTYPE" = Darwin ]; then
	ensure curl -LsSo ~/.bootstrap/brew-install.sh https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh
	ensure chmod +x ~/.bootstrap/brew-install.sh
	~/.bootstrap/brew-install.sh
fi

# Download basalt
if [ ! -d "$XDG_DATA_HOME/basalt/source" ]; then
	log_info 'Downloading basalt'
	ensure git clone --quiet https://github.com/hyperupcall/basalt "$XDG_DATA_HOME/basalt/source"
	ensure git -C "$XDG_DATA_HOME/basalt/source" submodule init
	ensure git -C "$XDG_DATA_HOME/basalt/source" submodule update
fi

eval "$("$XDG_DATA_HOME/basalt/source/pkg/bin/basalt" global init sh)"
log_info 'Downloading Basalt'
if ! "$XDG_DATA_HOME/basalt/source/pkg/bin/basalt" global add hyperupcall/dots-bootstrap &>/dev/null; then
	die "Could not download hyperupcall/dots-bootstrap repository"
fi

cat > ~/.bootstrap/profile-bootstrap.sh <<-"EOF"
	. ~/.bootstrap/profile-pre-bootstrap.sh
	export PATH="$HOME/.bootstrap/bin:$XDG_DATA_HOME/basalt/source/pkg/bin:$HOME/.bootstrap/nim-all/nim/bin:$PATH"
	eval "$("$XDG_DATA_HOME/basalt/source/pkg/bin/basalt" global init sh)"
EOF

cat <<-"EOF"
---
source ~/.bootstrap/profile-bootstrap.sh
dotfox --config-dir="$HOME/.dots/user/.config/dotfox" --deployment=all.sh deploy
---
EOF
