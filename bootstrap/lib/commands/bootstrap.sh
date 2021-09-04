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

# Install ~/.dots
if [ ! -d ~/.dots ]; then
	log_info 'Cloning gh:hyperupcall/dots'
	ensure git clone --quiet https://github.com/hyperupcall/dots ~/.dots
	ensure cd ~/.dots
	ensure git config --local filter.npmrc-clean.clean "$(pwd)/user/config/npm/npmrc-clean.sh"
	ensure git config --local filter.slack-term-config-clean.clean "$(pwd)/user/config/slack-term/slack-term-config-clean.sh"
	ensure git config --local filter.oscrc-clean.clean "$(pwd)/user/config/osc/oscrc-clean.sh"
	ensure cd ~
fi

# Download Nim (in case dotty doesn't work, it may need to be recompiled)
if [ ! -d ~/.bootstrap/nim-all/nim ]; then
	log_info 'Downloading Nim'
	ensure curl -LSso ~/.bootstrap/nim-all/nim-1.4.8-linux_x64.tar.xz https://nim-lang.org/download/nim-1.4.8-linux_x64.tar.xz
	ensure rm -rf ~/.bootstrap/nim-all/nim-1.4.8
	ensure cd ~/.bootstrap/nim-all
	ensure tar xf nim-1.4.8-linux_x64.tar.xz
	ensure cd ~
	ensure ln -sTf ~/.bootstrap/nim-all/nim-1.4.8 ~/.bootstrap/nim-all/nim
fi

if [ ! -d ~/.bootstrap/dotty ]; then
	log_info 'Cloning gh:hyperupcall/dotty'
	ensure git clone --quiet https://github.com/hyperupcall/dots ~/.bootstrap/dotty
fi

# Download Dotty
if [ ! -f ~/.bootstrap/bin/dotty ]; then
	log_info 'Downloading Dotty'
	if ! dotty_download_url="$(
		curl -LSs https://api.github.com/repos/hyperupcall/dotty/releases/latest \
			| jq -r '.assets[0].browser_download_url'
	)"; then
		die "Could not fetch the dotty download URL"
	fi
	ensure curl -LsSo ~/.bootstrap/bin/dotty "$dotty_download_url"
	ensure chmod +x ~/.bootstrap/bin/dotty
fi

# Download bpm
if [ ! -d "$XDG_DATA_HOME/bpm/source" ]; then
	log_info 'Downloading bpm'
	if ! bpm_download_url="$(
		curl -LSs https://api.github.com/repos/hyperupcall/bpm/releases/latest \
			| jq -r '.tarball_url'
	)"; then
		die "Could not fetch the bpm download URL"
	fi
	cd ~/.bootstrap
	ensure curl -LsSo bpm.tar.gz "$bpm_download_url"
	ensure tar xf bpm.tar.gz
	ensure mkdir -p "$XDG_DATA_HOME/bpm"
	mv hyperupcall-bpm-* "$XDG_DATA_HOME/bpm/source"
	cd ~
fi

eval "$("$XDG_DATA_HOME/bpm/source/pkg/bin/bpm" init sh)"
"$XDG_DATA_HOME/bpm/source/pkg/bin/bpm" --global add hyperupcall/dots-bootstrap

cat > ~/.bootstrap/profile-bootstrap.sh <<-"EOF"
	. ~/.bootstrap/profile-pre-bootstrap.sh
	export PATH="$HOME/.bootstrap/bin:$XDG_DATA_HOME/bpm/source/pkg/bin:$HOME/.bootstrap/nim-all/nim/bin:$PATH"
	eval "$("$XDG_DATA_HOME/bpm/source/pkg/bin/bpm" init sh)"
EOF

cat <<-"EOF"
---
bootstrap.sh finished. Next steps

source ~/.bootstrap/profile-bootstrap.sh
dotty --config-dir="$HOME/.dots/user/.config/dotty" --deployment=all.sh reconcile
EOF
