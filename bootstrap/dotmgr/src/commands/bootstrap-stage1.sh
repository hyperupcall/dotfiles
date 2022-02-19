# shellcheck shell=bash

# Assumptions:
# sudo, git, nvim installed
# hyperupcall/dots cloned
# dotmgr in PATH

subcommand() {
	if [ -z "$XDG_CONFIG_HOME" ]; then
		# shellcheck disable=SC2016
		print.die '$XDG_CONFIG_HOME is empty. Did you source profile-pre-bootstrap.sh?'
	fi

	if [ -z "$XDG_DATA_HOME" ]; then
		# shellcheck disable=SC2016
		print.die '$XDG_DATA_HOME is empty. Did you source profile-pre-bootstrap.sh?'
	fi

	# Ensure prerequisites
	mkdir -p ~/.bootstrap/{bin,nim-all,old-homedots} "$XDG_CONFIG_HOME"

	if ! util.is_cmd 'jq'; then
		print.info 'Installing jq'

		if util.is_cmd 'pacman'; then
			util.ensure sudo pacman -S --noconfirm 'jq'
		elif util.is_cmd 'apt-get'; then
			util.ensure sudo apt-get -y install 'jq'
		elif util.is_cmd 'dnf'; then
			util.ensure sudo dnf -y install 'jq'
		elif util.is_cmd 'zypper'; then
			util.ensure sudo zypper -y install 'jq'
		elif util.is_cmd 'eopkg'; then
			util.ensure sudo eopkg -y install 'jq'
		fi

		if ! util.is_cmd 'jq'; then
			print.die 'Automatic installation of jq failed'
		fi
	fi

	if ! util.is_cmd 'curl'; then
		print.info 'Installing curl'

		if util.is_cmd 'pacman'; then
			util.ensure sudo pacman -S --noconfirm 'curl'
		elif util.is_cmd 'apt-get'; then
			util.ensure sudo apt-get -y install 'curl'
		elif util.is_cmd 'dnf'; then
			util.ensure sudo dnf -y install 'curl'
		elif util.is_cmd 'zypper'; then
			util.ensure sudo zypper -y install 'curl'
		elif util.is_cmd 'eopkg'; then
			util.ensure sudo eopkg -y install 'curl'
		fi

		if ! util.is_cmd 'curl'; then
			print.die 'Automatic installation of curl failed'
		fi
	fi

	# Remove distribution specific dotfiles, including
	for file in ~/.bash_login ~/.bash_logout ~/.bash_profile ~/.bashrc ~/.profile; do
		if [[ ! -L "$file" && -f "$file" ]]; then
			util.ensure mv "$file" ~/.bootstrap/old-homedots
		fi
	done

	# Download Nim (in case dotfox doesn't work, it may need to be recompiled)
	if [ ! -d ~/.bootstrap/nim-all/nim ]; then
		print.info 'Downloading Nim'
		util.ensure curl -LSso ~/.bootstrap/nim-all/nim-1.4.8-linux_x64.tar.xz https://nim-lang.org/download/nim-1.4.8-linux_x64.tar.xz
		util.ensure rm -rf ~/.bootstrap/nim-all/nim-1.4.8
		util.ensure cd ~/.bootstrap/nim-all
		util.ensure tar xf nim-1.4.8-linux_x64.tar.xz
		util.ensure cd
		util.ensure ln -sTf ~/.bootstrap/nim-all/nim-1.4.8 ~/.bootstrap/nim-all/nim
	fi

	# Clone dotfox
	if [ ! -d ~/.bootstrap/dotfox ]; then
		print.info 'Cloning github.com/hyperupcall/dotfox'
		util.ensure git clone --quiet https://github.com/hyperupcall/dotfox ~/.bootstrap/dotfox
	fi

	# Download Dotfox
	if [ ! -f ~/.bootstrap/bin/dotfox ]; then
		print.info 'Downloading Dotfox'
		if ! dotfox_download_url="$(
			curl -LfSs https://api.github.com/repos/hyperupcall/dotfox/releases/latest \
				| jq -r '.assets[0].browser_download_url'
		)"; then
			print.die "Could not fetch the dotfox download URL"
		fi
		util.ensure curl -LsSo ~/.bootstrap/bin/dotfox "$dotfox_download_url"
		util.ensure chmod +x ~/.bootstrap/bin/dotfox
	fi

	# Download Basalt
	if [ ! -d "$XDG_DATA_HOME/basalt/source" ]; then
		print.info 'Downloading Basalt'
		util.ensure git clone --quiet https://github.com/hyperupcall/basalt "$XDG_DATA_HOME/basalt/source"
	fi

	# Install Homebrew
	if [ "$OSTYPE" = Darwin ]; then
		util.ensure curl -LsSo ~/.bootstrap/brew-install.sh https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh
		util.ensure chmod +x ~/.bootstrap/brew-install.sh
		~/.bootstrap/brew-install.sh
	fi

	# Download Basalt
	if [ ! -d "$XDG_DATA_HOME/basalt/source" ]; then
		print.info 'Downloading Basalt'
		util.ensure git clone --quiet https://github.com/hyperupcall/basalt "$XDG_DATA_HOME/basalt/source"
		util.ensure git -C "$XDG_DATA_HOME/basalt/source" submodule init
		util.ensure git -C "$XDG_DATA_HOME/basalt/source" submodule update
	fi

	if basalt_output="$("$XDG_DATA_HOME/basalt/source/pkg/bin/basalt" global init sh)"; then
		eval "$basalt_output"
	else
		print.die "Could not run 'basalt global init sh'"
	fi

	cat > ~/.bootstrap/stage2.sh <<-"EOF"
		. ~/.bootstrap/stage1.sh
		export PATH="$HOME/.bootstrap/dotfox:$HOME/.bootstrap/bin:$XDG_DATA_HOME/basalt/source/pkg/bin:$HOME/.bootstrap/nim-all/nim/bin:$PATH"

		if basalt_output="$("$XDG_DATA_HOME/basalt/source/pkg/bin/basalt" global init sh)"; then
		    eval "$basalt_output"
		else
		    printf '%s\n' "Could not run 'basalt global init sh'"
		fi
	EOF

	cat <<-"EOF"
	---
	. ~/.bootstrap/stage2.sh

	dotmgr action <action>
	---
	EOF
}
