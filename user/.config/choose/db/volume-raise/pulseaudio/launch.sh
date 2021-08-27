#!/usr/bin/env sh

pactl set-sink-volume @DEFAULT_SINK@ +10%
killall -SIGUSR1 i3status

pamixer --get-volume > "$XDG_RUNTIME_DIR/xob.sock"
