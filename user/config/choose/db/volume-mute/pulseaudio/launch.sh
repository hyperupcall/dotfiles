#!/usr/bin/env sh

pactl set-sink-mute @DEFAULT_SINK@ toggle
killall -SIGUSR1 i3status

pamixer --get-volume > "$XDG_RUNTIME_DIR/xob.sock"
