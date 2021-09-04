#!/usr/bin/env bash

if ((EUID == 0)); then
	sed -i -e 's/#Server/Server/g' /etc/pacman.d/mirrorlist
	pacman -S --noconfirm neovim
else
	source ~/.profile-tmp
	sudo chown -R "$USER:$USER" /mnt/shared
fi

DEV= /mnt/shared/dots-bootstrap/pre-bootstrap.sh
