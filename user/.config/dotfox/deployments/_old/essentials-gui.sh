#!/usr/bin/env bash
set -ETeo pipefail

source ./util/core.sh
source ./essentials-cli.sh

declare -a essenialsGuiDotFiles=(
	"$home/.xinitrc"
	"$cfg/i3"
	"$cfg/i3status"
	"$cfg/kitty"
	"$cfg/nitrogen"
	"$cfg/xbindkeys"
	"$cfg/X11"
)

printArray 'essentialsGuiDotFiles'
