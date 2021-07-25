#!/usr/bin/env bash

home="$HOME"
cfg="${XDG_CONFIG_HOME:-$HOME/.config}"
data="${XDG_DATA_HOME:-$HOME/.local/share}"

declare -ra dotFiles=(
	"$home/.alsoftrc"
	"$home/.bash_logout"
	"$home/.bash_profile"
	"$home/.bashrc"
	"$home/.config/conky"
	"$home/.config/wtf"
	"$home/.cpan/CPAN/MyConfig.pm"
	"$home/.hushlogin"
	# "$home/.pam_environment"
	"$home/.profile"
	"$home/.xinitrc"
	"$home/.yarnrc"
	"$cfg/aerc/aerc.conf"
	"$cfg/aerc/binds.conf"
	"$cfg/alacritty"
	"$cfg/albert/albert.conf"
	"$cfg/albert-sticker-searcher"
	"$cfg/alsa"
	"$cfg/appimagelauncher.cfg"
	"$cfg/aria2"
	"$cfg/awesome"
	"$cfg/bash"
	"$cfg/bat"
	"$cfg/broot"
	"$cfg/cabal/config"
	"$cfg/cactus"
	"$cfg/calcurse"
	"$cfg/cargo"
	"$cfg/cava"
	"$cfg/ccache"
	"$cfg/cdm"
	"$cfg/chezmoi"
	"$cfg/choose"
	"$cfg/cliflix"
	"$cfg/conda"
	"$cfg/conky"
	"$cfg/cookiecutter"
	"$cfg/cmus/rc"
	"$cfg/Code/User/keybindings.json"
	"$cfg/Code/User/settings.json"
	"$cfg/curl"
	"$cfg/ddcutil"
	"$cfg/dircolors"
	"$cfg/dotty"
	"$cfg/dunst"
	"$cfg/dxhd"
	"$cfg/emptty"
	"$cfg/environment.d"
	"$cfg/fish"
	"$cfg/fontconfig"
	"$cfg/gh/config.yml"
	"$cfg/gdb"
	"$cfg/git"
	"$cfg/glue"
	"$cfg/octave"
	"$cfg/osc"
	"$cfg/hg"
	"$cfg/htop"
	"$cfg/i3"
	"$cfg/i3status"
	"$cfg/info"
	"$cfg/ion"
	"$cfg/irb"
	"$cfg/irssi"
	"$cfg/kak"
	"$cfg/kermit"
	"$cfg/kitty"
	"$cfg/lazydocker"
	"$cfg/libfsguest"
	"$cfg/liquidprompt"
	"$cfg/llpp.conf"
	"$cfg/ly"
	"$cfg/maven"
	"$cfg/micro"
	"$cfg/mnemosyne/config.py"
	"$cfg/most"
	"$cfg/mpd"
	"$cfg/mpv"
	"$cfg/nano"
	"$cfg/nb"
	"$cfg/ncpamixer.conf"
	"$cfg/neofetch"
	"$cfg/nimble"
	"$cfg/nitrogen"
	"$cfg/npm"
	"$cfg/nu"
	"$cfg/nvchecker"
	"$cfg/nvim"
	"$cfg/openbox"
	"$cfg/OpenSCAD"
	"$cfg/ox"
	"$cfg/pacman"
	"$cfg/pacmixer"
	"$cfg/pamix.conf"
	"$cfg/paru"
	"$cfg/pavucontrol.ini"
	"$cfg/picom"
	"$cfg/pijul"
	"$cfg/please"
	"$cfg/polybar"
	"$cfg/powerline"
	"$cfg/pudb"
	"$cfg/pulse/client.conf"
	"$cfg/pulsemixer.cfg"
	"$cfg/pypoetry"
	"$cfg/python"
	"$cfg/quark"
	"$cfg/ranger"
	"$cfg/readline"
	"$cfg/redshift"
	"$cfg/ripgrep"
	"$cfg/rofi"
	"$cfg/rtorrent"
	"$cfg/salamis"
	"$cfg/shell"
	"$cfg/slack-term"
	"$cfg/starship"
	"$cfg/sticker-selector"
	"$cfg/sx"
	"$cfg/sxhkd"
	"$cfg/systemd"
	"$cfg/taskwarrior"
	"$cfg/terminator"
	"$cfg/termite"
	"$cfg/tig"
	"$cfg/tilda"
	"$cfg/tmux"
	"$cfg/toast"
	"$cfg/todotxt"
	"$cfg/twmn"
	"$cfg/urxvt"
	"$cfg/user-dirs.dirs"
	"$cfg/viewnior"
	"$cfg/vim"
	"$cfg/wget"
	"$cfg/wtf"
	"$cfg/xbindkeys"
	"$cfg/X11"
	"$cfg/xob"
	"$cfg/yay"
	"$cfg/youtube-dl"
	"$cfg/zsh"
	"$data/gnupg/gpg.conf"
	"$data/gnupg/dirmngr.conf"
	"$data/applications/Calcurse.desktop"
	"$data/sdkman/etc/config"
)

for dotFile in "${dotFiles[@]}"; do
	printf "%s\n" "$dotFile"
done
