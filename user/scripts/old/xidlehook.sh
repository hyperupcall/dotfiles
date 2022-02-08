#!/usr/bin/env sh

xidlehook \
	--not-when-fullscreen  \
	--not-when-audio \
	--timer 120 "$(cat <<-'EOF'
	for monitor in $(xrandr --listactivemonitors | awk '{ print $4 }' | xargs); do
		xrandr --output "$monitor" --brightness 0.5
	done
	EOF
	)" "$(cat <<-'EOF'
	for monitor in $(xrandr --listactivemonitors | awk '{ print $4 }' | xargs); do
		xrandr --output "$monitor" --brightness 1
	done
	EOF
	)" \
	--timer 10 "$(cat <<-'EOF'
	for monitor in $(xrandr --listactivemonitors | awk '{ print $4 }' | xargs); do
		xrandr --output "$monitor" --brightness 1
	done

	fox-default launch screen-lock-x
	EOF
	)" ''
