#!/usr/bin/env bash

set -uo pipefail

# ------------------- helper functions ------------------- #
function show_help() {
	cat <<-EOF
		Usage:
		    dot.sh [command]

		Commands:
		    pre-bootstrap
		        Performs pre-bootstrap operations

		    bootstrap [stage]
		        Bootstraps dotfiles, optionally add a stage to skip some steps

		    misc
		        Reconciles state

		    info
		        Prints info

		Examples:
		    dot.sh bootstrap i_rust
	EOF
}

function check_prerequisites() (
	ensure() {
		: ${1:?"Error: check_prerequisites: 'binary' command not passed"}

		type "$1" >&/dev/null || {
			log_error "Error: '$1' not found. Exiting early"
			exit 1
		}
	}

	[[ $(id -un) = edwin ]] || {
		log_error "Error: 'id -un' not 'edwin'. Exiting early"
		exit 1
	}

	ensure git
	# sdkman
	ensure zip
	# g
	ensure make
	# starsnip
	ensure pkg-config

)

# sources profiles before boostrap
function source_profile() {
	[ -d ~/.dots ] && {
		set +u
		source ~/.dots/user/.profile
		set -u
		return
	}

	pushd "$(mktemp -d)"
	req -o temp-profile.sh https://raw.githubusercontent.com/eankeen/dots/main/user/.profile
	set +u
	. temp-profile.sh
	set -u
	popd
}

function install_packages() {
	immediate_packages="git zip make pkg-config"
	packages="gcc clang vlc cmus zsh restic rofi trash-cli pkg-config wget rsync"

	type apt &>/dev/null && {
		sudo apt install -y $immediate_packages
		sudo apt install -y libssl-dev
		sudo apt install -y $packages

		sudo apt install -y scrot xclip maim libssl-dev
	}

	type zypper &>/dev/null && {
		sudo zypper install -y $immediate_packages
		sudo zypper install -y openssl-devel
		sudo zypper install -y $packages

		sudo zypper install -y scrot xclip maim youtube-dl exa bsdtar
	}

	type yum &>/dev/null && {
		sudo yum install -y $immediate_packages
		sudo yum install -y openssl-devel
		sudo yum install $packages

		sudo yum install -y code
	}

	type pacman &>/dev/null && {
		# gpg --refresh-keys
		# pacman-key --init && pacman-key --populate archlinux
		# pacman-key --refresh-key

		sudo pacman -Syyu --noconfirm
		sudo pacman -Sy --noconfirm base-devel

		sudo pacman -Sy --noconfirm $immediate_packages
		sudo pacman -Sy --noconfirm $packages
			
		sudo pacman -Sy man-pages
		sudo pacman -Sy inetutils bat i3 man-db lvm2 exa
		sudo pacman -Sy linux-lts bash-completion linux-lts-docs linux-lts-headers nvidia-lts

		type yay &>/dev/null || (
			cd "$(mktemp -d)"
			git clone https://aur.archlinux.org/yay.git
			cd yay
			makepkg -si
		)

		yay -Sy all-repository-fonts
	}
}

function req() {
	curl --proto '=https' --tlsv1.2 -sSLf "$@"
}

function log_info() {
	printf "\033[0;34m%s\033[0m\n" "INFO: $@"
}

function log_error() {
	printf "\033[0;31m%s\033[0m\n" "ERROR: $@" >&2
}



# --------------------- pre-bootstrap -------------------- #
do_pre-bootstrap() {
	## get basics out of the day
	# network
	local interface
	interface=(/sys/class/net/en*)
	interface="${interface##*/}"
	[ -e /etc/systemd/network/90-main.network ] || {
		sudo tee /etc/systemd/network/90-main.network <<-EOF
		[Match]
		Name=$interface

		[Network]
		Description=Main Network
		DHCP=yes
		DNS=1.1.1.1
		EOF

		sudo systemctl daemon-reload
		sudo systemctl enable --now systemd-networkd.service
		sudo systemctl enable --now systemd-resolved.service

		false
	} && {
		echo "90-main.network already exists. Enabling and starting services"

		sudo systemctl enable --now systemd-networkd.service
		sudo systemctl enable --now systemd-resolved.service
	}

	ping 1.1.1.1 -c1 -W2 &>/dev/null || {
		log_error "Error: 'ping 1.1.1.1' failed. Exiting early"
		exit 1
	}

	ping google.com -c1 -W2 &>/dev/null || {
		log_error "Error: 'ping google.com' failed. Exiting early"
		exit 1
	}

	[ -r /etc/hostname ] && {
		log_info "Current Hostname: $(</etc/hostname)"
	}
	read -ri "New Hostname? "
	sudo hostname "$REPLY"
	sudo tee /etc/hostname <<< "$REPLY" >&/dev/null

	grep -qe "$REPLY" /etc/hosts || {
		sudo tee /etc/hosts <<-END >&/dev/null
		# IP-Address  Full-Qualified-Hostname  Short-Hostname
		127.0.0.1       localhost
		::1             localhost ipv6-localhost ipv6-loopback
		fe00::0         ipv6-localnet
		ff00::0         ipv6-mcastprefix
		ff02::1         ipv6-allnodes
		ff02::2         ipv6-allrouters
		ff02::3         ipv6-allhosts
		END
		sudo vim /etc/hosts
	}

	# disks / fstab
	grep -qe '# XDG Desktop Entries' /etc/fstab \
	|| sudo tee -a /etc/fstab >/dev/null <<-EOF
	# XDG Desktop Entries
	/dev/fox/stg.files  /storage/edwin  xfs  defaults,relatime,X-mount.mkdir=0755  0  2
	/storage/edwin/Music  /home/edwin/Music  none  x-systemd.after=/data/edwin,X-mount.mkdir,bind,nofail  0  0
	/storage/edwin/Pics  /home/edwin/Pics  none  x-systemd.after=/data/edwin,X-mount.mkdir,bind,nofail  0  0
	/storage/edwin/Vids  /home/edwin/Vids  none  x-systemd.after=/data/edwin,X-mount.mkdir,bind,nofail  0  0
	/storage/edwin/Dls  /home/edwin/Dls  none  x-systemd.after=/data/edwin,X-mount.mkdir,bind,nofail  0  0
	/storage/edwin/Docs  /home/edwin/Docs  none  x-systemd.after=/data/edwin,X-mount.mkdir,bind,nofail  0  0

	# Data Bind Mounts
	/dev/fox/stg.data  /storage/data  reiserfs defaults,X-mount.mkdir  0 0
	/storage/data/calcurse  /home/edwin/data/calcurse  none  x-systemd.after=/storage/data,X-mount.mkdir,bind,nofail  0 0
	/storage/data/gnupg  /home/edwin/data/gnupg  none  x-systemd.after=/storage/data,X-mount.mkdir,bind,nofail  0 0
	/storage/data/fonts  /home/edwin/data/fonts  none x-systemd.after=/storage/data,X-mount.mkdir,bind,nofail  0 0
	/storage/data/BraveSoftware /home/edwin/config/BraveSoftware  none x-systemd.after=/storage/data,X-mount.mkdir,bind,nofail  0 0
	/storage/data/ssh /home/edwin/.ssh  none x-systemd.after=/storage/data,X-mount.mkdir,bind,nofail  0 0
	EOF

	sudo mount -a || {
		log_error "Error: 'mount -a' failed. Exiting early"
		exit 1
	}

	# todo: move
	( [ "$(stat -c "%U" ~/config)" = "root" ] || [ "$(stat -c "%G" ~/config)" = "root" ] || [ "$(stat -c "%U" ~/data)" = "root" ] || [ "$(stat -c "%G" ~/data)" = "root" ] || [ "$(stat -c "%U" ~/.vscode/extensions)" = "root" ]  || [ "$(stat -c "%G" ~/.vscode/extensions)" = "root" ] ) && {
		sudo chown edwin:edwin ~/config ~/data ~/.vscode/extensions
	}

	# date
	sudo timedatectl set ntp true
	sudo timedatectl set-timezone America/Los_Angeles
	# ln -sf /usr/share/zoneinfo/America/Los_Angeles /etc/localtime
	sudo hwclock --systohc

	# locales
	sudo sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
	sudo locale-gen



	## bootstrap own dotfiles (for now 'dotty' has no up to date binary releases so just build from source)
	type go &>/dev/null || {
		source_profile # get XDG_CONFIG_HOME, GO_ROOT etc.
		curl -sSL https://git.io/g-install | sh -s
		source_profile # superfluous
	}

	type go &>/dev/null || {
		log_error "Error: 'go' not found, but should be as we just installed it. Exiting early"
		exit 1
	}

	type git &>/dev/null || {
		log_error "Error: 'git' not found. Install it"
		exit 1
	}

	# move dots
	mkdir ~/.old >&/dev/null
	mv ~/.profile ~/.old &>/dev/null
	mv ~/.bashrc ~/.old &>/dev/null
	mv ~/.bash_login ~/.old &>/dev/null
	mv ~/.bash_logout ~/.old &>/dev/null

# ensure we have some basics
	declare -ra cmds=(ip xss-lock buildah git dhclient bat i3 fzf man exa wikit ranger neofetch glances browsh lxd figlet wget curl make clang code zip scrot xclip maim pkg-config youtube-dl nordvpn vlc cmus restic rofi trash-rm)
	for cmd in ${cmds[@]}; do
		command -V "$cmd" >/dev/null
	done


	# setup links
	ln -s ~/Docs/Programming/repos ~/repos &>/dev/null
	ln -s ~/Docs/Programming/projects ~/projects &>/dev/null
	ln -s ~/Docs/Programming/workspaces ~/workspaces &>/dev/null
	mkdir -p ~/.history
	mkdir -p ~/data/X11

	# setup users
	sudo groupadd docker
	sudo groupadd libvirt
	sudo groupadd vboxusers
	sudo groupadd lxd
	sudo groupadd systemd-journal
	sudo groupadd nordvpn
	#sudo groupadd adm, wheel
	sudo usermod -aG docker,libvirt,vboxusers,lxd,systemd-journal,nordvpn edwin

	mkdir -p "$SONARLINT_USER_HOME"

	cat ~/.gitconfig <<-EOF
	[user]
		name = Edwin Kofler
		email = 24364012+eankeen@users.noreply.github.com
	EOF

	cd ~/Docs/Programming/repos/dotty
	go install .

	[ -d ~/.dots ] || git clone https://github.com/eankeen/dots ~/.dots
	dotty user apply --dotfiles-dir="$HOME/.dots" || {
		log_error "Error: Could not apply user dotfiles. Exiting"
		return 1
	}
	source ~/.profile
	[[ -n $BASH ]] && source ~/.bashrc

	fn="${1:-}"
	[[ -n $fn ]] && {
		"$fn"
		return
	}

	i_rust
}

# ----------------------- bootstrap ---------------------- #
do_bootstrap() {
	## pre-checks
	[[ $(id -un) = edwin ]] || {
		log_error "Error: 'id -un' not 'edwin'. Exiting early"
		exit 1
	}

	type sudo &>/dev/null || {
		log_error "Error: 'sudo' not found. Exiting early"
		exit 1
	}

	fn="${1:-}"
	[[ -n $fn ]] && {
		"$fn"
		return
	}
}

bootstrap_done() {
	cat <<-EOF
	Things Taken Care of:
	  - network
	  - /etc/hostname
	  - fstab bind mounts
	  - chown ~/config,~/data,~/.vscode/extensions
	  - timedatectl, hwclock
	  - locales

	Remember:
	  - /etc/hosts?
	  - fstab main mounts

	  - mkinitcpio
	  - Initramfs / Kernel (lvm2)
	  - Root Password
	  - Bootloader / refind
	  - Clean up ~/.profile,~/.bashrc
	  - Compile at /usr/share/doc/git/contrib/credential/libsecret/git-credential-libsecret
	  - Remove ~/.gitconfig
	EOF

}

i_rust() {
	log_info "Installing rustup"
	req https://sh.rustup.rs | sh -s -- --default-toolchain stable -y
	cargo install broot
	cargo install just
	cargo install starship
	cargo install git-delta
	cargo install paru
	rustup default nightly

	i_node
}

# todo: remove prompt
i_node() {
	log_info "Installing n"
	req https://raw.githubusercontent.com/mklement0/n-install/stable/bin/n-install | bash
	npm i -g yarn
	npm i -g pnpm
	pnpm i -g diff-so-fancy
	pnpm i -g cliflix
	pnpm install -g nb.sh
	yarn config set prefix "$XDG_DATA_HOME/yarn"

	i_dvm
}

i_dvm() {
	log_info "Installing dvm"
	req https://deno.land/x/dvm/install.sh | sh
	dvm install

	i_ruby
}

i_ruby() {
	log_info "Installing rvm"
	gpg --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
	req https://get.rvm.io | bash -s -- --path "$XDG_DATA_HOME/rvm"

	i_python
}

i_python() {
	log_info "Installing pyenv"
	req https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash

	# ensure installation: libffi-devel
	pyenv install 3.9.0
	pyenv global 3.9.0

	log_info "Installing poetry"
	req https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python -

	pip install -U kb-manager

	i_nim
}

i_nim() {
	log_info "Installing choosenim"
	req https://nim-lang.org/choosenim/init.sh | sh
	nimble install nimcr

	i_zsh
}

i_zsh() {
	log_info "Installing zsh"
	git clone https://github.com/ohmyzsh/oh-my-zsh "$XDG_DATA_HOME/oh-my-zsh"

	i_sdkman
}

i_sdkman() {
	log_info "Installing sdkman"
	curl -s "https://get.sdkman.io" | bash

	i_tmux
}

i_tmux() {
	log_info "Installing tpm"
	git clone https://github.com/tmux-plugins/tpm "$XDG_DATA_HOME/tmux/plugins/tpm"

	i_bash
}

i_bash() {
	log_info "Installing bash-it"
	git clone https://github.com/bash-it/bash-it "$XDG_DATA_HOME/bash-it"
	source "$XDG_DATA_HOME/bash-it/install.sh" --no-modify-config

	log_info "Installing bash-git-prompt"
	git clone https://github.com/magicmonty/bash-git-prompt "$XDG_DATA_HOME/bash-git-prompt"

	log_info "Installing bookmarks.sh"
	git clone https://github.com/huyng/bashmarks

	i_go
}

# todo: remove prompt
i_go() {
	log_info "Installing g"
	curl -sSL https://git.io/g-install | sh -s
	go get -v golang.org/x/tools/gopls

	i_php
}

i_php() {
	log_info "Installing phpenv"
	req https://raw.githubusercontent.com/phpenv/phpenv-installer/master/bin/phpenv-installer \
		| PHPENV_ROOT=$HOME/data/phpenv bash

	i_perl
}

# todo: remove prompt (on unconfigured systems)
i_perl() {
	log_info "Installing perl"
	# https://github.com/regnarg/urxvt-config-reload
	cpan AnyEvent Linux::FD common::sense

	bootstrap_done
}


do_post() {
	if [ "$(curl -LsSo- https://edwin.dev)" = "Hello World" ]; then
		:
	else
		echo "https://edwin.dev OPEN"
	fi
}



# ------------------------- info ------------------------- #
do_info() {
	lstopo
}



## start
[[ $* =~ (--help) ]] && {
	show_help
	exit 0
}

[[ ${BASH_SOURCE[0]} != "$0" ]] && {
	log_info "Info: Sourcing detected. Sourcing old profile and exiting"
	source_profile

	return 0
}

case "${1:-''}" in
pre-bootstrap)
	shift
	do_pre-bootstrap "$@"
	;;
bootstrap)
	shift
	do_bootstrap "$@"
	;;
misc)
	shift
	do_misc "$@"
	;;
info)
	shift
	do_info "$@"
	;;
*)
	log_error "Error: No matching subcommand found"
	show_help
	exit 1
	;;
esac
