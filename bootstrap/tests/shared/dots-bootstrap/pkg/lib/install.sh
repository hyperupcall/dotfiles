# shellcheck shell=bash

# TODO: cleanup
# fox-default autoinstall / switch system
# could replace some of this
# ansible ad-hoc
{
	type pacman &>/dev/null && {
		# gpg --refresh-keys
		# pacman-key --init && pacman-key --populate archlinux
		# pacman-key --refresh-key

		sudo pacman -Syyu --noconfirm
		sudo pacman -Sy --noconfirm base-devel
		# devel
		sudo pacman -Syu make clang zip pkg-config  trash-cli gcc clang
		# core
		sudo pacman -Syu bash-completion wget
		# core auxillary
		sudo pacman -Syu vlc cmus maim zsh youtube-dl restic rofi trash-cli
		sudo pacman -Syu nordvpn zip xss-lock man-db man-pages xss-lock
		sudo pacman -Syu exa bat fzf figlet rsync
		sudo pacman -Sy inetutils i3 lvm2 lesspipe
		sudo pacman -Sy linux-lts  linux-lts-docs linux-lts-headers nvidia-lts

		type yay &>/dev/null || (
			cd "$(mktemp -d)" || die "Could not mktemp"
			git clone https://aur.archlinux.org/yay.git
			cd yay || die "Could not cd"
			makepkg -si
		)

		yay -Sy all-repository-fonts
	}


	ensure_bin() {
		: "${1:?"Error: check_prerequisites: 'binary' command not passed"}"

		type "$1" >&/dev/null || {
			die "Error: '$1' not found. Exiting early"
		}
	}

	ensure_bin git
	ensure_bin zip # sdkman
	ensure_bin make # g
	ensure_bin pkg-config # starship
	# todo: the following are packages not binaries. make binaries or do ensurePkg
	#ensure_bin curl # ghcup
	#ensure_bin g++ # ghcup
	ensure_bin gcc # ghcup
	#ensure_bin gmp # ghcup
	ensure_bin make # ghcup
	#ensure_bin ncurses # ghcup
	ensure_bin realpath # ghcup
	#ensure_bin xz-utils # ghcup
}
