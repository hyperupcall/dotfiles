# shellcheck shell=bash
# shellcheck shell=bash

# TODO: cleanup
# fox-default autoinstall / switch system
# could replace some of this
# ansible ad-hoc
# {
# 	type pacman &>/dev/null && {
# 		# gpg --refresh-keys
# 		# pacman-key --init && pacman-key --populate archlinux
# 		# pacman-key --refresh-key

# 		sudo pacman -Syyu --noconfirm
# 		sudo pacman -Sy --noconfirm base-devel
# 		# devel
# 		sudo pacman -Syu make clang zip pkg-config  trash-cli gcc clang
# 		# core
# 		sudo pacman -Syu bash-completion wget
# 		# core auxillary
# 		sudo pacman -Syu vlc cmus maim zsh youtube-dl restic rofi trash-cli
# 		sudo pacman -Syu nordvpn zip xss-lock man-db man-pages xss-lock
# 		sudo pacman -Syu exa bat fzf figlet rsync
# 		sudo pacman -Sy inetutils i3 lvm2 lesspipe
# 		sudo pacman -Sy linux-lts  linux-lts-docs linux-lts-headers nvidia-lts

# 		type yay &>/dev/null || (
# 			cd "$(mktemp -d)" || die "Could not mktemp"
# 			git clone https://aur.archlinux.org/yay.git
# 			cd yay || die "Could not cd"
# 			makepkg -si
# 		)

# 		yay -Sy all-repository-fonts
# 	}


# 	ensure_bin() {
# 		: "${1:?"Error: check_prerequisites: 'binary' command not passed"}"

# 		type "$1" >&/dev/null || {
# 			die "Error: '$1' not found. Exiting early"
# 		}
# 	}

# 	ensure_bin git
# 	ensure_bin zip # sdkman
# 	ensure_bin make # g
# 	ensure_bin pkg-config # starship
# 	# todo: the following are packages not binaries. make binaries or do ensurePkg
# 	#ensure_bin curl # ghcup
# 	#ensure_bin g++ # ghcup
# 	ensure_bin gcc # ghcup
# 	#ensure_bin gmp # ghcup
# 	ensure_bin make # ghcup
# 	#ensure_bin ncurses # ghcup
# 	ensure_bin realpath # ghcup
# 	#ensure_bin xz-utils # ghcup
# }

# -------------------- ensure network -------------------- #
# TODO
ensure ping google.com -c1 -W2 &>/dev/null

# --------------------- set hostname --------------------- #

read -rp "Choose new hostname: " -ei "$(</etc/hostname)"
ensure sudo hostnamectl set-hostname "$REPLY"
ensure sudo tee /etc/hostname <<< "$REPLY" &>/dev/null


# ----------------------- set hosts ---------------------- #

if ! grep -qe "$REPLY" /etc/hosts; then
	sudo tee -a /etc/hosts <<-EOF >&/dev/null
	# IP-Address  Full-Qualified-Hostname  Short-Hostname
	127.0.0.1       localhost
	::1             localhost ipv6-localhost ipv6-loopback
	fe00::0         ipv6-localnet
	ff00::0         ipv6-mcastprefix
	ff02::1         ipv6-allnodes
	ff02::2         ipv6-allrouters
	ff02::3         ipv6-allhosts
	EOF

	echo "Check/edit /etc/hosts..."
	read -rsn 1
	sudo "$EDITOR" /etc/hosts
fi


# --------------------- update fstab --------------------- #

if ! grep -qe '# extra' /etc/fstab; then
	if [ -e /dev/fox ]; then
		sudo tee -a /etc/fstab >/dev/null <<-EOF
		# Extra
		/dev/fox/stg.files  /storage/edwin  xfs  defaults,relatime,X-mount.mkdir=0755  0  2
		/dev/fox/stg.data  /storage/data  reiserfs defaults,X-mount.mkdir  0 0
		EOF
	fi

	echo "Check/edit /etc/fstab..."
	read -rsn 1
	sudo "$EDITOR" /etc/fstab
fi

if ! sudo mount -a; then
	log_error "Error: 'mount -a' failed. Exiting early"
	[[ -v DEV ]] || exit 1
fi

# ------------------------- date ------------------------- #

ensure sudo timedatectl set-ntp true
ensure sudo timedatectl set-timezone America/Los_Angeles
ensure sudo hwclock --systohc || die 'hwclock --systohc failed'


# ------------------------ locales ----------------------- #

ensure sudo sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
ensure sudo locale-gen


# ------------------------ groups ------------------------ #

# TODO: check /usr/lib/sysgroups.d
ensure sudo groupadd -f docker
ensure sudo groupadd -f libvirt
ensure sudo groupadd -f vboxusers
ensure sudo groupadd -f lxd
ensure sudo groupadd -f systemd-journal
ensure sudo groupadd -f nordvpn
ensure sudo usermod -aG docker,libvirt,vboxusers,lxd,systemd-journal,nordvpn "$USER"
