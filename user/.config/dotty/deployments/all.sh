#!/usr/bin/env bash
set -ETeo pipefail

if [ -f ~/.dots/xdg.sh ]; then
	source ~/.dots/xdg.sh
else
	printf '%s\n' "Error: ~/.dots/xdg.sh not found. Exiting"
	exit 1
fi

declare -ra dotfiles=(
	home:".alsoftrc"
	home:".config/conky" # TODO
	home:".config/wtf" # TODO
	home:".cpan/CPAN/MyConfig.pm"
	home:".hushlogin"
	home:".pam_environment"
	home:".yarnrc"
	cfg:"aerc/aerc.conf"
	cfg:"aerc/binds.conf"
	cfg:"alacritty"
	cfg:"albert/albert.conf"
	cfg:"albert-sticker-searcher"
	cfg:"alsa"
	cfg:"appimagelauncher.cfg"
	cfg:"aria2"
	cfg:"awesome"
	cfg:"bash"
	cfg:"bat"
	cfg:"bpython"
	cfg:"broot"
	cfg:"cabal/config"
	cfg:"cactus"
	cfg:"calcurse"
	cfg:"cargo"
	cfg:"cava"
	cfg:"ccache"
	cfg:"cdm"
	cfg:"chezmoi"
	cfg:"choose"
	cfg:"cliflix"
	cfg:"conda"
	cfg:"conky"
	cfg:"cookiecutter"
	cfg:"cmus/rc"
	cfg:"Code/User/keybindings.json"
	cfg:"Code/User/settings.json"
	cfg:"curl"
	cfg:"ddcutil"
	cfg:"dircolors"
	cfg:"dotty"
	cfg:"dunst"
	cfg:"dxhd"
	cfg:"emptty"
	cfg:"environment.d"
	cfg:"fish"
	cfg:"fontconfig"
	cfg:"gh/config.yml"
	cfg:"gdb"
	cfg:"git"
	cfg:"glue"
	cfg:"octave"
	cfg:"osc"
	cfg:"hg"
	cfg:"htop"
	cfg:"i3"
	cfg:"i3blocks"
	cfg:"i3status"
	cfg:"info"
	cfg:"ion"
	cfg:"irb"
	cfg:"irssi"
	cfg:"kak"
	cfg:"kermit"
	cfg:"kitty"
	cfg:"lazydocker"
	cfg:"libfsguest"
	cfg:"liquidprompt"
	cfg:"llpp.conf"
	cfg:"ly"
	cfg:"maven"
	cfg:"micro"
	cfg:"mnemosyne/config.py"
	cfg:"most"
	cfg:"mpd"
	cfg:"mpv"
	cfg:"namur"
	cfg:"nano"
	cfg:"nb"
	cfg:"ncpamixer.conf"
	cfg:"neofetch"
	cfg:"nimble"
	cfg:"nitrogen"
	cfg:"npm"
	cfg:"nu"
	cfg:"nvchecker"
	cfg:"nvim"
	cfg:"openbox"
	cfg:"OpenSCAD"
	cfg:"ox"
	cfg:"pacman"
	cfg:"pacmixer"
	cfg:"pamix.conf"
	cfg:"paru"
	cfg:"pavucontrol.ini"
	cfg:"picom"
	cfg:"pijul"
	cfg:"please"
	cfg:"polybar"
	cfg:"powerline"
	cfg:"pudb"
	cfg:"pulse/client.conf"
	cfg:"pulsemixer.cfg"
	cfg:"pypoetry"
	cfg:"python"
	cfg:"quark"
	cfg:"ranger"
	cfg:"readline"
	cfg:"redshift"
	cfg:"ripgrep"
	cfg:"rofi"
	cfg:"rtorrent"
	cfg:"salamis"
	cfg:"shell"
	cfg:"slack-term"
	cfg:"starship"
	cfg:"sticker-selector"
	cfg:"sx"
	cfg:"sxhkd"
	cfg:"systemd"
	cfg:"taffybar"
	cfg:"taskwarrior"
	cfg:"terminator"
	cfg:"termite"
	cfg:"tig"
	cfg:"tilda"
	cfg:"tmux"
	cfg:"toast"
	cfg:"todotxt"
	cfg:"twmn"
	cfg:"urxvt"
	cfg:"user-dirs.dirs"
	cfg:"viewnior"
	cfg:"vim"
	cfg:"wget"
	cfg:"wtf"
	cfg:"xbindkeys"
	cfg:"X11"
	cfg:"xmobar"
	cfg:"xob"
	cfg:"yay"
	cfg:"youtube-dl"
	cfg:"zsh"
	data:"gnupg/gpg.conf"
	data:"gnupg/dirmngr.conf"
	data:"applications/Calcurse.desktop"
	data:"sdkman/etc/config"
)

# Print actual dotfiles
src_home="$HOME/.dots/user"
src_cfg="$HOME/.dots/user/.config"
src_state="$HOME/.dota/user/.local/state"
src_data="$HOME/.dots/user/.local/share"

dest_home="$HOME"
dest_cfg="$XDG_CONFIG_HOME"
dest_state="$XDG_STATE_HOME"
dest_data="$XDG_DATA_HOME"

for dotfile in "${dotfiles[@]}"; do
	prefix="${dotfile%%:*}"
	file="${dotfile#*:}"

	case "$file" in *:*)
		printf '%s\n' "Error: Files must not have colons, but file '$file' does. Exiting"
		exit 1
	;; esac

	if [ "$prefix" = home ]; then
		printf '%s\n' "symlink:$src_home/$file:$dest_home/$file"
	elif [ "$prefix" = cfg ]; then
		printf '%s\n' "symlink:$src_cfg/$file:$dest_cfg/$file"
	elif [ "$prefix" = state ]; then
		printf '%s\n' "symlink:$src_state/$file:$dest_state/$file"
	elif [ "$prefix" = data ]; then
		printf '%s\n' "symlink:$src_data/$file:$dest_data/$file"
	else
		printf '%s\n' "Error: Prefix '$prefix' not supported (for file '$file'). Exiting"
		exit 1
	fi
done

# Internal symlinking
cat <<-EOF

symlink:$XDG_CONFIG_HOME/X11/xinitrc:$HOME/.xinitrc
symlink:$XDG_CONFIG_HOME/bash/bash_profile.sh:$HOME/.bash_profile
symlink:$XDG_CONFIG_HOME/bash/bash_logout.sh:$HOME/.bash_logout
symlink:$XDG_CONFIG_HOME/bash/bashrc.sh:$HOME/.bashrc
symlink:$XDG_CONFIG_HOME/shell/profile.sh:$HOME/.profile
EOF

# Perform symlinking to external storage
storage_prefix="/storage/data"

cat <<-EOF

symlink:$storage_prefix/BraveSoftware:$XDG_CONFIG_HOME/BraveSoftware
symlink:$storage_prefix/calcurse:$XDG_CONFIG_HOME/calcurse
symlink:$storage_prefix/fonts:$XDG_CONFIG_HOME/fonts
symlink:$storage_prefix/mozilla:$HOME/.mozilla
symlink:$storage_prefix/password-store:$XDG_DATA_HOME/password-store
symlink:$storage_prefix/ssh:$HOME/.ssh
EOF
