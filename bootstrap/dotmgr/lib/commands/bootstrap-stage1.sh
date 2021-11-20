# shellcheck shell=bash

subcmd() {
	if [ -z "$XDG_CONFIG_HOME" ]; then
		util.die '$XDG_CONFIG_HOME is empty. Did you source profile-pre-bootstrap.sh?'
	fi

	if [ -z "$XDG_DATA_HOME" ]; then
		util.die '$XDG_DATA_HOME is empty. Did you source profile-pre-bootstrap.sh?'
	fi

	# Ensure prerequisites
	mkdir -p ~/.bootstrap/{bin,nim-all,old-dots} "$XDG_CONFIG_HOME"
	for cmd in git curl; do
		if ! command -v "$cmd" >/dev/null 2>&1; then
			util.die "$cmd not installed"
		fi
	done

	# Remove distribution specific dotfiles, including
	for file in ~/.bash_login ~/.bash_logout ~/.bash_profile ~/.bashrc ~/.profile; do
		if [ -f "$file" ]; then
			util.ensure mv "$file" ~/.bootstrap/old-dots
		fi
	done

	# Download Nim (in case dotfox doesn't work, it may need to be recompiled)
	if [ ! -d ~/.bootstrap/nim-all/nim ]; then
		util.log_info 'Downloading Nim'
		util.ensure curl -LSso ~/.bootstrap/nim-all/nim-1.4.8-linux_x64.tar.xz https://nim-lang.org/download/nim-1.4.8-linux_x64.tar.xz
		util.ensure rm -rf ~/.bootstrap/nim-all/nim-1.4.8
		util.ensure cd ~/.bootstrap/nim-all
		util.ensure tar xf nim-1.4.8-linux_x64.tar.xz
		util.ensure cd
		util.ensure ln -sTf ~/.bootstrap/nim-all/nim-1.4.8 ~/.bootstrap/nim-all/nim
	fi

	if [ ! -d ~/.bootstrap/dotfox ]; then
		util.log_info 'Cloning github.com/hyperupcall/dotfox'
		util.ensure git clone --quiet https://github.com/hyperupcall/dotfox ~/.bootstrap/dotfox
	fi

	# Download Basalt
	if [ ! -d "$XDG_DATA_HOME/basalt/source" ]; then
		log_info 'Downloading Basalt'
		ensure git clone --quiet https://github.com/hyperupcall/basalt "$XDG_DATA_HOME/basalt/source"
	fi
	
	# Download Dotfox
	if [ ! -f ~/.bootstrap/bin/dotfox ]; then
		util.log_info 'Downloading Dotfox'
		if ! dotfox_download_url="$(
			curl -LfSs https://api.github.com/repos/hyperupcall/dotfox/releases/latest \
				| jq -r '.assets[0].browser_download_url'
		)"; then
			util.die "Could not fetch the dotfox download URL"
		fi
		util.ensure curl -LsSo ~/.bootstrap/bin/dotfox "$dotfox_download_url"
		util.ensure chmod +x ~/.bootstrap/bin/dotfox
	fi

	# Install Homebrew
	if [ "$OSTYPE" = Darwin ]; then
		util.ensure curl -LsSo ~/.bootstrap/brew-install.sh https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh
		util.ensure chmod +x ~/.bootstrap/brew-install.sh
		~/.bootstrap/brew-install.sh
	fi

	# Download Basalt
	if [ ! -d "$XDG_DATA_HOME/basalt/source" ]; then
		util.log_info 'Downloading Basalt'
		util.ensure git clone --quiet https://github.com/hyperupcall/basalt "$XDG_DATA_HOME/basalt/source"
		util.ensure git -C "$XDG_DATA_HOME/basalt/source" submodule init
		util.ensure git -C "$XDG_DATA_HOME/basalt/source" submodule update
	fi

	if basalt_output="$("$XDG_DATA_HOME/basalt/source/pkg/bin/basalt" global init sh)"; then
		eval "$basalt_output"
	else
		util.die "Could not run 'basalt global init sh'"
	fi

	cat > ~/.bootstrap/stage-2.sh <<-"EOF"
		. ~/.bootstrap/stage-1.sh
		export PATH="$HOME/.bootstrap/dotfox:$HOME/.bootstrap/bin:$XDG_DATA_HOME/basalt/source/pkg/bin:$HOME/.bootstrap/nim-all/nim/bin:$PATH"

		if basalt_output="$("$XDG_DATA_HOME/basalt/source/pkg/bin/basalt" global init sh)"; then
			eval "$basalt_output"
		else
			printf '%s\n' "Could not run 'basalt global init sh'"
		fi
	EOF

	cat <<-"EOF"
	---
	. ~/.bootstrap/stage-2.sh
	dotfox --config-dir="$HOME/.dots/user/.config/dotfox" --deployment=all.sh deploy
	dotmgr maintain
	. ~/.bashrc
	dotmgr bootstrap-stage2
	---
	EOF
}
