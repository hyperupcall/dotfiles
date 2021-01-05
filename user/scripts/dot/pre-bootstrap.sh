# shellcheck shell=bash

# --------------------- pre-bootstrap -------------------- #
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

	cd ~/Docs/Programming/repos/dotty || die "Could not cd into ~/Docs/Programming/repos/dotty"
	go install .

	[ -d ~/.dots ] || git clone https://github.com/eankeen/dots ~/.dots
	dotty user apply --dotfiles-dir="$HOME/.dots" || {
		log_error "Error: Could not apply user dotfiles. Exiting"
		return 1
	}
