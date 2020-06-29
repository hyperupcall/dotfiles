#!/bin/sh -eu

function primary {
	xrandr \
		--output DP-5 --auto \
		--output DP-3 --below DP-3 --auto \
		--output DP-3 --left-of HDMI-0 --auto \
		--output DVI-D-0 --right-of HDMI-0 --rotate left --auto
}

