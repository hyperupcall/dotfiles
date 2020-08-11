#!/bin/sh -eu

primary() {
	xrandr \
		--output DP-5 --above DP-3 --auto \
		--output DP-3 --below DP-5 --auto \
		--output DP-5 --left-of HDMI-0 --auto \
		--output DP-1 --right-of DP-3 --auto
#		--output DP-1 --right-of HDMI-0 --rotate left --auto
}
