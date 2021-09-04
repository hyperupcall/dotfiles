# shellcheck shell=bash

#
# ─── SETUP SYSTEM ───────────────────────────────────────────────────────────────
#

# -------------------- ensure network -------------------- #

ensure ping google.com -c1 -W2 &>/dev/null


# --------------------- set hostname --------------------- #

read -rp "Choose new hostname: " -ei "$(</etc/hostname)"
ensure sudo hostnamectl set-hostname "$REPLY"
ensure sudo tee /etc/hostname <<< "$REPLY" &>/dev/null


# ----------------------- set hosts ---------------------- #

grep -qe "$REPLY" /etc/hosts || {
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

	read -rp "Check/edit /etc/hosts..." -sn 1
	sudo "${EDITOR:-vim}" /etc/hosts
}


# --------------------- update fstab --------------------- #

grep -qe '# extra' /etc/fstab || {
	if [ -e /dev/fox ]; then
		sudo tee -a /etc/fstab >/dev/null <<-EOF
		# Extra
		/dev/fox/stg.files  /storage/edwin  xfs  defaults,relatime,X-mount.mkdir=0755  0  2
		/dev/fox/stg.data  /storage/data  reiserfs defaults,X-mount.mkdir  0 0
		EOF
	fi

	read -rp "Check/edit /etc/fstab..." -sn 1
	sudo "${EDITOR:-vim}" /etc/fstab
}

sudo mount -a || {
	log_error "Error: 'mount -a' failed. Exiting early"
	[[ -v DEV ]] || exit 1
}

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

#
# ─── INSTALL ACTUAL DOTFILES ────────────────────────────────────────────────────
#

# remove anything inherited from /etc/skell
{
	mkdir -p ~/.old
	mv ~/.bash_login ~/.old
	mv ~/.bash_logout ~/.old
	mv ~/.bash_profile ~/.old
	mv ~/.bashrc ~/.old
	mv ~/.profile ~/.old
} >&/dev/null

[ -d ~/.dots ] || {
	git clone https://github.com/eankeen/dots ~/.dots
	cd ~/.dots || die "Could not 'cd dots'"
	git config --local filter.npmrc-clean.clean "$(pwd)/user/config/npm/npmrc-clean.sh"
	git config --local filter.slack-term-config-clean.clean "$(pwd)/user/config/slack-term/slack-term-config-clean.sh"
	git config --local filter.oscrc-clean.clean "$(pwd)/user/config/osc/oscrc-clean.sh"
}

# TODO: use latest
curl -LO https://github.com/eankeen/dotty/releases/download/v0.5.0/dotty
chmod +x dotty
./dotty reconcile

#
# ─── CONCLUSION ─────────────────────────────────────────────────────────────────
#

cat <<-EOF
	Prerequisites
	  - Network
	  - dotty
	  - cURL

	Bootstrapped:
	  - /etc/hostname
	  - /etc/hosts
	  - /etc/fstab
	  - timedatectl
	  - hwlock
	  - /etc/locale.gen
	  - locale-gen
	  - groupadd {docker,lxd,...}
	  - passwd
	  - eankeen/dotty

	Remember:
	  - dots-bootstrap install
	  - mkinitcpio
	  - Initramfs / Kernel (lvm2)
	  - Root Password
	  - Bootloader / refind
	  - Compile at /usr/share/doc/git/contrib/credential/libsecret/git-credential-libsecret
EOF
