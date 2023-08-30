#!/usr/bin/env bash
set -eo pipefail

declare dotdir="$HOME/.dotfiles"

if [ -f "$dotdir/xdg.sh" ]; then
	source "$dotdir/xdg.sh" --export-vars
else
	printf '%s\n' "Error: $dotdir/xdg.sh not found. Exiting" >&2
	exit 1
fi

if ! [[ -v 'XDG_CONFIG_HOME' && -v 'XDG_STATE_HOME' && -v 'XDG_DATA_HOME' ]]; then
	printf '%s\n' "Error: XDG Variables cannot be empty. Exiting" >&2
	exit 1
fi

declare -ra dotfiles=(
	home:'.agignore'
	home:'.alsoftrc'
	home:'.cpan/CPAN/MyConfig.pm'
	home:'.digrc'
	home:'.gnuplot'
	home:'.keep'
	home:'.psqlrc'
	home:'.gnupg/dirmngr.conf'
	home:'.gnupg/gpg.conf'
	home:'.gnupg/gpg-agent.conf'
	home:'.hushlogin'
	# home:'.yarnrc'
	cfg:'.gtktermrc'
	cfg:'rofi-json-menu.json'
	cfg:'aerc/aerc.conf'
	cfg:'aerc/binds.conf'
	cfg:'alacritty'
	cfg:'albert/albert.conf'
	cfg:'alsa'
	cfg:'appimagelauncher.cfg'
	cfg:'aria2'
	cfg:'aspell'
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
	cfg:'dotfox'
	cfg:'dotmgr'
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

main() {
	local dotdrop_file="$HOME/.dotfiles/os/unix/config/dotdrop/dotdrop.yaml"
	local dotdrop_include_file="$HOME/.dotfiles/os/unix/config/dotdrop/dotdrop-include.yaml"
	mkdir -p "${dotdrop_file%/*}"
	> "$dotdrop_include_file" :
	> "$dotdrop_file" :
	cat <<"EOF" > "$dotdrop_include_file"
dotfiles:
EOF
	cat <<"EOF" > "$dotdrop_file"
config:
  backup: true
  banner: false
  check_version: true
  create: true
  dotpath: '~/.dotfiles/os/unix/user'
  link_dotfile_default: 'relative'
  link_on_import: 'relative'
  template_dotfile_default: false
  workdir: '~/.dotfiles/.dotdrop-workdir'

profiles:
  nullptr:
    variables:
      email: 'edwin@kofler.dev'
      home_src: '.'
      cfg_src: '.config'
      state_src: '.local/state'
      data_src: '.local/share'
    dynvariables:
      home_dst: 'printf "%s\n" "$HOME"'
      cfg_dst: 'printf "%s\n" "$XDG_CONFIG_HOME"'
      state_dst: 'printf "%s\n" "$XDG_STATE_HOME"'
      data_dst: 'printf "%s\n" "$XDG_DATA_HOME"'
    import:
      - './dotdrop-include.yaml'

dotfiles:
EOF

	# Print actual dotfiles
	src_home="$dotdir/os/unix/user"
	src_cfg="$dotdir/os/unix/user/.config"
	src_state="$dotdir/os/unix/user/.local/state"
	src_data="$dotdir/os/unix/user/.local/share"
	local -A src_map=(
		[home]="$src_home"
		[cfg]="$src_cfg"
		[state]="$src_state"
		[data]="$src_data"
	)
	local -A src_map_rel=(
		[home]=""
		[cfg]=".config"
		[state]=".local/state"
		[data]=".local/share"
	)
	local -A dst_map=(
		[home]="$HOME"
		[cfg]="$XDG_CONFIG_HOME"
		[state]="$XDG_STATE_HOME"
		[data]="$XDG_DATA_HOME"
	)
	for dotfile in "${dotfiles[@]}"; do
		local prefix=${dotfile%%:*}
		local file=${dotfile#*:}

		case "$file" in *:*)
			printf '%s\n' "Error: Files must not have colons, but file '$file' does. Exiting" >&2
			exit 1
			;;
		esac

		if [ -z "${src_map[$prefix]}" ] || [ -z "${dst_map[$prefix]}" ]; then
			printf '%s\n' "Error: Prefix '$prefix' not supported (for file '$file'). Exiting" >&2
			exit 1
		fi
		printf '%s\n' "symlink|${src_map[$prefix]}/$file|${dst_map[$prefix]}/$file"

		# dotdrop
		local dundered_path="${dst_map[$prefix]}/$file"
		dundered_path=${dundered_path#~/}
		dundered_path=${dundered_path//\//__}
		printf '%s\n' "  $dundered_path:
    src: '{{@@ ${prefix}_src @@}}/$file'
    dst: '{{@@ ${prefix}_dst @@}}/.$file'" >> "$dotdrop_file"
		printf '%s\n' "  - '$dundered_path'" >> "$dotdrop_include_file"
	done


	# Print dotfiles that do not share a common prefix
	printf '%s\n' "symlink|$XDG_CONFIG_HOME/X11/xinitrc|$HOME/.xinitrc"
	printf '%s\n' "symlink|$XDG_CONFIG_HOME/bash/bash_profile.sh|$HOME/.bash_profile"
	printf '%s\n' "symlink|$XDG_CONFIG_HOME/bash/bash_logout.sh|$HOME/.bash_logout"
	printf '%s\n' "symlink|$XDG_CONFIG_HOME/bash/bashrc.sh|$HOME/.bashrc"
	printf '%s\n' "symlink|$XDG_CONFIG_HOME/shell/profile.sh|$HOME/.profile"
	printf '%s\n' "symlink|$XDG_CONFIG_HOME/zsh/.zshenv|$HOME/.zshenv"

	# Print dotfiles programatically
	source "$dotdir/xdg.sh" --set-type
	if [ "$REPLY" = default ]; then
		printf '%s\n' "symlink|$src_home/.pam_environment/xdg-default.conf|$HOME/.pam_environment"
	elif [ "$REPLY" = custom ]; then
		printf '%s\n' "symlink|$src_home/.pam_environment/xdg-custom.conf|$HOME/.pam_environment"
	fi
}

main "$@"
