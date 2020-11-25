#!/usr/bin/env sh

xrandr \
	--output DP-3 --right-of DP-5 \
	--output DP-1 --above DP-5 \
	--output HDMI-0 --above DP-3
