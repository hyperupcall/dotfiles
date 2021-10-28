#!/usr/bin/env bash
set -ETeo pipefail

if [ -f ~/.dots/xdg.sh ]; then
	source ~/.dots/xdg.sh --export-vars
else
	printf '%s\n' "Error: ~/.dots/xdg.sh not found. Exiting"
	exit 1
fi

# TODO:
# mkdir:"$XDG_CONFIG_HOME/yarn"
# touch:"$XDG_CONFIG_HOME/yarn/config"
declare -ra dotfiles=(
	home:'.alsoftrc'
	home:'.config/conky' # TODO
	home:'.config/wtf' # TODO
	home:'.cpan/CPAN/MyConfig.pm'
	home:'.hushlogin'
	home:'.yarnrc'
	cfg:'aerc/aerc.conf'
	cfg:'aerc/binds.conf'
	cfg:'alacritty'
	cfg:'albert/albert.conf'
	cfg:'albert-sticker-searcher'
	cfg:'alsa'
	cfg:'appimagelauncher.cfg'
	cfg:'aria2'
	cfg:'awesome'
	cfg:'bash'
	cfg:'bat'
	cfg:'bpython'
	cfg:'broot'
	cfg:'bspwm'
	cfg:'cabal/config'
	cfg:'cactus'
	cfg:'cargo'
	cfg:'cava'
	cfg:'ccache'
	cfg:'cdm'
	cfg:'chezmoi'
	cfg:'choose'
	cfg:'cliflix'
	cfg:'conda'
	cfg:'conky'
	cfg:'cookiecutter'
	cfg:'cmus/rc'
	cfg:'Code/User/keybindings.json'
	cfg:'Code/User/settings.json'
	cfg:'curl'
	cfg:'ddcutil'
	cfg:'dircolors'
	cfg:'discocss'
	cfg:'dotfox'
	cfg:'dotshellgen'
	cfg:'dunst'
	cfg:'dxhd'
	cfg:'emptty'
	cfg:'environment.d'
	cfg:'eww'
	cfg:'fish'
	cfg:'fontconfig'
	cfg:'gh/config.yml'
	cfg:'gdb'
	cfg:'git'
	cfg:'glue'
	cfg:'octave'
	cfg:'osc'
	cfg:'hg'
	cfg:'htop'
	cfg:'i3'
	cfg:'i3blocks'
	cfg:'i3status'
	cfg:'info'
	cfg:'ion'
	cfg:'irb'
	cfg:'irssi'
	cfg:'kak'
	cfg:'kermit'
	cfg:'kitty'
	cfg:'lazydocker'
	cfg:'libfsguest'
	cfg:'liquidprompt'
	cfg:'llpp.conf'
	cfg:'ly'
	cfg:'maco'
	cfg:'maven'
	cfg:'micro'
	cfg:'mimeapps.list'
	cfg:'mnemosyne/config.py'
	cfg:'most'
	cfg:'mpd'
	cfg:'mpv'
	cfg:'namur'
	cfg:'nano'
	cfg:'nb'
	cfg:'ncmpcpp'
	cfg:'ncpamixer.conf'
	cfg:'neofetch'
	# cfg:'neomutt'
	cfg:'nimble'
	cfg:'nitrogen'
	cfg:'notmuch'
	cfg:'npm'
	cfg:'nu'
	cfg:'nvchecker'
	cfg:'nvim'
	cfg:'openbox'
	cfg:'OpenSCAD'
	cfg:'ox'
	cfg:'pacman'
	cfg:'pacmixer'
	cfg:'pamix.conf'
	cfg:'paru'
	cfg:'pavucontrol.ini'
	cfg:'pgcli'
	cfg:'picom'
	cfg:'pijul'
	cfg:'please'
	cfg:'polybar'
	cfg:'powerline'
	cfg:'pudb'
	cfg:'pulse/client.conf'
	cfg:'pulsemixer.cfg'
	cfg:'pylint'
	cfg:'pypoetry'
	cfg:'python'
	cfg:'quark'
	cfg:'ranger'
	cfg:'readline'
	cfg:'redshift'
	cfg:'repoctl'
	cfg:'ripgrep'
	cfg:'rofi'
	cfg:'rtorrent'
	cfg:'salamis'
	cfg:'shell'
	cfg:'slack-term'
	cfg:'starship'
	cfg:'sticker-selector'
	cfg:'sx'
	cfg:'sxhkd'
	cfg:'swaylock'
	cfg:'systemd'
	cfg:'taffybar'
	cfg:'taskwarrior'
	cfg:'terminator'
	cfg:'termite'
	cfg:'tig'
	cfg:'tilda'
	cfg:'tmux'
	cfg:'toast'
	cfg:'todotxt'
	cfg:'twmn'
	cfg:'udiskie'
	cfg:'urlwatch'
	cfg:'urxvt'
	cfg:'user-dirs.dirs'
	cfg:'viewnior'
	cfg:'vim'
	cfg:'wget'
	cfg:'wtf'
	cfg:'xbindkeys'
	cfg:'X11'
	cfg:'xkb'
	cfg:'xmobar'
	cfg:'xob'
	cfg:'xplr'
	cfg:'yay'
	cfg:'youtube-dl'
	cfg:'zathura'
	cfg:'zsh'
	data:'gnupg/dirmngr.conf'
	data:'gnupg/gpg.conf'
	data:'gnupg/gpg-agent.conf'
	data:'applications/calcurse.desktop'
	data:'applications/kakoune.desktop'
	data:'applications/FoxBlender.desktop'
	data:'sdkman/etc/config'
	state:'dotshellgen'
)

# Print actual dotfiles
src_home="$HOME/.dots/user"
src_cfg="$HOME/.dots/user/.config"
src_state="$HOME/.dots/user/.local/state"
src_data="$HOME/.dots/user/.local/share"

for dotfile in "${dotfiles[@]}"; do
	prefix="${dotfile%%:*}"
	file="${dotfile#*:}"

	case "$file" in *:*)
		printf '%s\n' "Error: Files must not have colons, but file '$file' does. Exiting"
		exit 1
	;; esac

	if [ "$prefix" = home ]; then
		printf '%s\n' "symlink:$src_home/$file:$HOME/$file"
	elif [ "$prefix" = cfg ]; then
		printf '%s\n' "symlink:$src_cfg/$file:$XDG_CONFIG_HOME/$file"
	elif [ "$prefix" = state ]; then
		printf '%s\n' "symlink:$src_state/$file:$XDG_STATE_HOME/$file"
	elif [ "$prefix" = data ]; then
		printf '%s\n' "symlink:$src_data/$file:$XDG_DATA_HOME/$file"
	else
		printf '%s\n' "Error: Prefix '$prefix' not supported (for file '$file'). Exiting"
		exit 1
	fi
done

storage_home="/storage/ur/storage_home"
storage_other="/storage/ur/storage_other"
storage_bridge="/storage/ur/bridge"

cat <<-EOF

# to dotfile
symlink:$XDG_CONFIG_HOME/X11/xinitrc:$HOME/.xinitrc
symlink:$XDG_CONFIG_HOME/bash/bash_profile.sh:$HOME/.bash_profile
symlink:$XDG_CONFIG_HOME/bash/bash_logout.sh:$HOME/.bash_logout
symlink:$XDG_CONFIG_HOME/bash/bashrc.sh:$HOME/.bashrc
symlink:$XDG_CONFIG_HOME/shell/profile.sh:$HOME/.profile

# to storage
symlink:$storage_home/Dls:$HOME/Dls
symlink:$storage_home/Docs:$HOME/Docs
symlink:$storage_home/Music:$HOME/Music
symlink:$storage_home/Pics:$HOME/Pics
symlink:$storage_home/Vids:$HOME/Vids
symlink:$storage_other/BraveSoftware:$XDG_CONFIG_HOME/BraveSoftware
symlink:$storage_other/calcurse:$XDG_CONFIG_HOME/calcurse
symlink:$storage_other/fonts:$XDG_CONFIG_HOME/fonts
symlink:$storage_other/mozilla:$HOME/.mozilla
symlink:$storage_other/ssh:$HOME/.ssh
symlink:$storage_bridge/password-store:$XDG_DATA_HOME/password-store

# to other
EOF

# Custom
source ~/.dots/xdg.sh --set-type
if [ "$REPLY" = default ]; then
	cat <<-EOF
	symlink:$src_home/.pam_environment/xdg-default.conf:$HOME/.pam_environment
	EOF
elif [ "$REPLY" = custom ]; then
	cat <<-EOF
	symlink:$src_home/.pam_environment/xdg-custom.conf:$HOME/.pam_environment
	EOF
fi

if [ -d ~/.gnupg ]; then
	cat <<-EOF

	symlink:$XDG_DATA_HOME/gnupg/dirmngr.conf:$HOME/.gnupg/dirmngr.conf
	symlink:$XDG_DATA_HOME/gnupg/gpg.conf:$HOME/.gnupg/gpg.conf
	symlink:$XDG_DATA_HOME/gnupg/gpg-agent.conf:$HOME/.gnupg/gpg-agent.conf
	EOF
fi