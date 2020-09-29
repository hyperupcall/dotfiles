#!/bin/sh -eu

primary() {
	xrandr \
		--output DP-5 --above DP-3 --auto \
		--output DP-3 --below DP-5 --auto \
		--output HDMI-0 --right-of DP-5 --auto \
		--output DP-1 --right-of DP-3 --auto
}

secondary() {
	xrandr \
		--output DP-5 --above DP-3 --auto \
		--output DP-1 --right-of DP-3 --auto \
		--output HDMI-0 --right-of DP-1 --rotate left --auto
}
