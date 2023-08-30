# shellcheck shell=bash

c.export_xdg_vars() {
	if [ -f "$dotdir/xdg.sh" ]; then
		source "$dotdir/xdg.sh" --export-vars
		if ! [[ -v 'XDG_CONFIG_HOME' ]]; then
			printf '%s\n' "Error: XDG Variables cannot be empty. Exiting" >&2
			exit 1
		fi
	else
		printf '%s\n' "Error: $dotdir/xdg.sh not found. Exiting" >&2
		exit 1
	fi
}

c.dotfiles() {
	local arr_name=$1
	local loopfn=$2

	if [ -n "$arr_name" ]; then
		local -n arr=$arr_name
	fi

	for dotfile in "${g_dotfiles[@]}"; do
		local str=
		if [[ "$dotfile" == *:* ]]; then
			local prefix=${dotfile%%:*}
			local file=${dotfile#*:}

			if [ -z "${g_dotfiles_src[$prefix]}" ] || [ -z "${g_dotfiles_dst[$prefix]}" ]; then
				printf '%s\n' "Error: Prefix '$prefix' not supported (for file '$file'). Exiting" >&2
				exit 1
			fi

			str="symlink|${g_dotfiles_src[$prefix]}/$file|${g_dotfiles_dst[$prefix]}/$file"

			if [ "$loopfn" ]; then
				"$loopfn" "$prefix"
			fi
		else
			str="symlink|$dotfile"
		fi

		if [ -n "$arr_name" ]; then
			arr+=("$str")
		else
			printf '%s\n' "$str"
		fi
	done

	# Print dotfiles programatically
	local str=
	source "$dotdir/xdg.sh" --set-type
	if [ "$REPLY" = default ]; then
		str="symlink|${g_dotfiles_src[home]}/.pam_environment/xdg-default.conf|${g_dotfiles_dst[home]}/.pam_environment"
	elif [ "$REPLY" = custom ]; then
		str="symlink|${g_dotfiles_src[home]}/.pam_environment/xdg-custom.conf|${g_dotfiles_dst[home]}/.pam_environment"
	fi
	if [ -n "$arr_name" ]; then
		arr+=("$str")
	else
		printf '%s\n' "$str"
	fi
}

declare -grA g_dotfiles_src=(
	[home]="$dotdir"
	[cfg]="$dotdir/.config"
	[state]="$dotdir/.local/state"
	[data]="$dotdir/.local/share"
)

declare -grA g_dotfiles_dst=(
	[home]="$HOME"
	[cfg]="$XDG_CONFIG_HOME"
	[state]="$XDG_STATE_HOME"
	[data]="$XDG_DATA_HOME"
)

declare -gra g_dotfiles=(
	home:'.agignore'
	home:'.alsoftrc'
	home:'.aspell.conf'
	home:'.cpan/CPAN/MyConfig.pm'
	home:'.digrc'
	home:'.gnuplot'
	home:'.psqlrc'
	home:'.gnupg/dirmngr.conf'
	home:'.gnupg/gpg.conf'
	home:'.gnupg/gpg-agent.conf'
	home:'.hushlogin'
	# home:'.yarnrc'
	"${g_dotfiles_dst[cfg]}/X11/xinitrc|${g_dotfiles_dst[home]}/.xinitrc"
	"${g_dotfiles_dst[cfg]}/bash/bash_profile.sh|${g_dotfiles_dst[home]}/.bash_profile"
	"${g_dotfiles_dst[cfg]}/bash/bash_logout.sh|${g_dotfiles_dst[home]}/.bash_logout"
	"${g_dotfiles_dst[cfg]}/bash/bashrc.sh|${g_dotfiles_dst[home]}/.bashrc"
	"${g_dotfiles_dst[cfg]}/shell/profile.sh|${g_dotfiles_dst[home]}/.profile"
	"${g_dotfiles_dst[cfg]}/zsh/.zshenv|${g_dotfiles_dst[home]}/.zshenv"
	cfg:'.gtktermrc'
	cfg:'rofi-json-menu.json'
	cfg:'aerc/aerc.conf'
	cfg:'aerc/binds.conf'
	cfg:'alacritty'
	cfg:'albert/albert.conf'
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
	cfg:'calcurse'
	cfg:'cargo'
	cfg:'cava'
	cfg:'ccache'
	cfg:'cdm'
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
	cfg:'helix'
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
	cfg:'quasipanacea'
	cfg:'kermit'
	cfg:'kitty'
	cfg:'lazydocker'
	cfg:'less'
	cfg:'libfsguest'
	cfg:'liquidprompt'
	cfg:'llpp.conf'
	cfg:'ltrace'
	cfg:'ly'
	cfg:'maven'
	cfg:'micro/bindings.json'
	cfg:'micro/settings.json'
	# cfg:'mimeapps.list'
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
	cfg:'obs-studio/themes'
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
	cfg:'sheldon'
	cfg:'shell'
	cfg:'slack-term'
	cfg:'starship'
	cfg:'sticker-selector'
	cfg:'sublime-text-3/Packages/User/Preferences.sublime-settings'
	cfg:'sublime-text-3/Packages/User/Package Control.sublime-settings'
	cfg:'sx'
	cfg:'sxhkd'
	cfg:'swaylock'
	cfg:'taffybar'
	cfg:'taskwarrior'
	cfg:'terminator'
	cfg:'termite'
	cfg:'tig'
	cfg:'tmux'
	cfg:'toast'
	cfg:'twmn'
	cfg:'udiskie'
	cfg:'urlwatch'
	cfg:'urxvt'
	# cfg:'user-dirs.dirs' # Handled by 'dotmgr action idempotent'
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
	cfg:'yapf'
	cfg:'yay'
	cfg:'youtube-dl'
	cfg:'zathura'
	cfg:'zsh'
	data:'applications/FoxBlender.desktop'
	data:'sdkman/etc/config'
	state:'dotshellgen'
)
