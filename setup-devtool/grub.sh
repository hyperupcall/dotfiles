#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='GRUB'

install.any() {
	sudo apt-get -y update
	sudo apt-get -y install fonts-ubuntu
	local size=36
	sudo grub-mkfont -s $size -o /boot/grub/fonts/ubuntu-mono.pf2 /usr/share/fonts/truetype/ubuntu/UbuntuMono-R.ttf
	sudo grub-mkfont -s $size -o /boot/grub/fonts/dejavu-mono.pf2 /usr/share/fonts/truetype/dejavu/DejaVuSansMono.ttf

	cat >/etc/default/grub/50-override.sh <<EOF
# Skip filesystem check.
GRUB_CMDLINE_LINUX="$(/usr/share/juno-grub/juno-grub)"

# Custom assets.
#GRUB_FONT=/boot/grub/fonts/ubuntu-mono.pf2
GRUB_FONT=/boot/grub/fonts/dejavu-mono.pf2
GRUB_GFXMODE=2560x1600
GRUB_BACKGROUND/boot/grub/background.png
EOF
}

install.installed() {
	:
}

util.if_file_sourced || _setup "$@"
