# shellcheck shell=bash

module() {
	sudo pacman -S docker pigz docker-scan  lazydocker kitematic dive
}

module "$@"
