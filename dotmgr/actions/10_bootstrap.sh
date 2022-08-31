# shellcheck shell=bash

# Name:
# Bootstrap
#
# Description:
# Bootstraps dotfiles
#
# It may install the following:
# - jq
# - curl
# - Nim (in ~/.bootstrap)
# - Dotfox (in ~/.bootstrap)
# - Basalt
main() {
	if [ -d ~/.bootstrap ]; then
		if util.prompt "It seems you have already bootstraped your dotfiles, do you wish to do it again?"; then :; else
			util.die 'Exiting'
		fi
	fi

	# Ensure prerequisites
	mkdir -p ~/.bootstrap/{bin,nim-all,old-homedots} "$XDG_CONFIG_HOME"

	if util.is_cmd 'jq'; then
		core.print_info 'Already installed jq'
	else
		core.print_info 'Installing jq'

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
		elif iscmd 'brew'; then
			ensure brew install 'jq'
		fi

		if ! util.is_cmd 'jq'; then
			core.print_die 'Automatic installation of jq failed'
		fi
	fi

	if util.is_cmd 'curl'; then
		core.print_info 'Already installed curl'
	else
		core.print_info 'Installing curl'

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
		elif iscmd 'brew'; then
			ensure brew install 'curl'
		fi

		if ! util.is_cmd 'curl'; then
			core.print_die 'Automatic installation of curl failed'
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
		core.print_info 'Downloading Nim'
		util.ensure curl -LSso ~/.bootstrap/nim-all/nim-1.4.8-linux_x64.tar.xz https://nim-lang.org/download/nim-1.4.8-linux_x64.tar.xz
		util.ensure rm -rf ~/.bootstrap/nim-all/nim-1.4.8
		util.ensure cd ~/.bootstrap/nim-all
		util.ensure tar xf nim-1.4.8-linux_x64.tar.xz
		util.ensure cd
		util.ensure ln -sTf ~/.bootstrap/nim-all/nim-1.4.8 ~/.bootstrap/nim-all/nim
	fi

	# Clone dotfox
	if [ ! -d ~/.bootstrap/dotfox ]; then
		core.print_info 'Cloning github.com/hyperupcall/dotfox'
		util.ensure git clone --quiet https://github.com/hyperupcall/dotfox ~/.bootstrap/dotfox
		(
			cd ~/.bootstrap/dotfox
			"$HOME/.bootstrap/nim-all/nim/bin/nimble" -y --nim="$HOME/.bootstrap/nim-all/nim/bin/nim" build
		)
	fi

	# Download Dotfox
	if [ ! -f ~/.bootstrap/bin/dotfox ]; then
		core.print_info 'Downloading Dotfox'
		if ! dotfox_download_url="$(
			curl -LfSs https://api.github.com/repos/hyperupcall/dotfox/releases/latest \
				| jq -r '.assets[0].browser_download_url'
		)"; then
			core.print_die "Could not fetch the dotfox download URL"
		fi
		util.ensure curl -LsSo ~/.bootstrap/bin/dotfox "$dotfox_download_url"
		util.ensure chmod +x ~/.bootstrap/bin/dotfox
	fi

	# Download Basalt
	if [ ! -d "$XDG_DATA_HOME/basalt/source" ]; then
		core.print_info 'Downloading Basalt'
		util.ensure git clone --quiet https://github.com/hyperupcall/basalt "$XDG_DATA_HOME/basalt/source"
		util.ensure git -C "$XDG_DATA_HOME/basalt/source" submodule init
		util.ensure git -C "$XDG_DATA_HOME/basalt/source" submodule update
	fi

	local basalt_output=
	if basalt_output=$("$XDG_DATA_HOME/basalt/source/pkg/bin/basalt" global init bash); then
		eval "$basalt_output"
	else
		core.print_die "Could not run 'basalt global init bash'"
	fi

	cat > ~/.bootstrap/bootstrap-out.sh <<"EOF"
. ~/.bootstrap/stage0-out.sh
export PATH="$HOME/.bootstrap/dotfox:$XDG_DATA_HOME/basalt/source/pkg/bin:$HOME/.bootstrap/nim-all/nim/bin:$PATH"

if basalt_output=$("$XDG_DATA_HOME/basalt/source/pkg/bin/basalt" global init sh); then
    eval "$basalt_output"
else
    printf '%s\n' "Could not run 'basalt global init sh'"
fi
EOF

	cat <<"EOF"
---
. ~/.bootstrap/bootstrap-out.sh

dotmgr action <action>
---
EOF
}
