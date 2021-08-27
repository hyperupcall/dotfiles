#!/usr/bin/env bash
set -ETeo pipefail

source ./util/core.sh
source ./optional-cli.sh

declare -a optionalGuiDotFiles=(
	"$cfg/alacritty"
	"$cfg/awesome"
	"$cfg/cactus"
	"$cfg/cdm"
	"$cfg/cliflix"
	"$cfg/conky"
	"$cfg/dunst"
	"$cfg/dxhd"
	"$cfg/octave"
	"$cfg/kermit"
	"$cfg/micro"
	"$cfg/mnemosyne/config.py"
	"$cfg/nitrogen"
	"$cfg/openbox"
	"$cfg/OpenSCAD"
	"$cfg/picom"
	"$cfg/polybar"
	"$cfg/redshift"
	"$cfg/rofi"
	"$cfg/sticker-selector"
	"$cfg/sx"
	"$cfg/sxhkd"
	"$cfg/terminator"
	"$cfg/termite"
	"$cfg/twmn"
	"$cfg/urxvt"
	"$cfg/viewnior"
	"$cfg/xob"
)

printArray 'optionalGuiDotFiles'
