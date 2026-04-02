#!/usr/bin/env bash
source ~/.dotfiles/data/setup.sh

declare -g g_name='podman'

install.debian() {
	sudo apt-get install -y podman
	flatpak remote-add --if-not-exists --user flathub https://flathub.org/repo/flathub.flatpakrepo
	flatpak install -y --user flathub io.podman_desktop.PodmanDesktop
}

install.ubuntu() {
	install.debian "$@"
}

install.fedora() {
	sudo dnf -y install podman
	flatpak remote-add --if-not-exists --user flathub https://flathub.org/repo/flathub.flatpakrepo
	flatpak install -y --user flathub io.podman_desktop.PodmanDesktop
}

install.opensuse() {
	sudo zypper -n install podman
	flatpak remote-add --if-not-exists --user flathub https://flathub.org/repo/flathub.flatpakrepo
	flatpak install -y --user flathub io.podman_desktop.PodmanDesktop
}

installed() {
	command -v podman &>/dev/null
}

util.if_file_sourced || _setup "$@"
