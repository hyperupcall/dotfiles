# shellcheck shell=bash

# Name:
# Primary
#
# Description:
# Adds user to various groups

{
	declare n="${1:-15}"

	sudo ~/git/acdcontrol/acdcontrol /dev/usb/hiddev1 -- $((n+15))
	sudo ddccontrol dev:/dev/i2c-4 -r 0x10 -w "$n"
	sudo ddccontrol dev:/dev/i2c-7 -r 0x10 -w "$n"
}