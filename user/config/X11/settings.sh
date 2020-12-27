#!/usr/bin/env sh

xbacklight -set 100

# xhost gives X server access for same user processes on localhost.
# Safe since the kernel can check the actual owner of the calling process
xhost +si:localuser:"$(id -un)"
#xhost +local:root

xmodmap "$XDG_CONFIG_HOME/X11/Xmodmap"

xrandr \
	--output DP-5 --left-of HDMI-0 \
	--output DP-1 --above HDMI-0

xrdb -load "$XDG_CONFIG_HOME/X11/Xresources"

xset b off
xset -dpms
xset +fp "$XDG_DATA_HOME/fonts"
xset fp rehash
xset led off
xset m 0 0
xset r rate 500 40

xsetroot -default
xsetroot -xcf /usr/share/icons/breeze_cursors/cursors/left_ptr 4
xsetroot -mod 8 8
xsetroot -solid '#212529'
