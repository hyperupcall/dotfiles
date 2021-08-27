#!/usr/bin/env sh

for monitor in $(xrandr --listactivemonitors | awk '{ print $4 }' | xargs); do
	xrandr --output "$monitor" --brightness 4 &
done

wait
