#!/usr/bin/env sh

# starts at 10:30
notify-send -u critical "SHUTDOWN NOTICE" "5 Minutes until shutting everything down"
sleep "$((60 * 4))"

# 10:34
notify-send -u critical "SHUTDOWN NOTICE" "1 Minute until shutting everything down"
sleep 30

# 10:34:30
notify-send -u critical "SHUTDOWN NOTICE" "30 Seconds until shutting everything down"
monitors="$(xrandr --listactivemonitors | awk '{ print $4 }' | xargs)"
for monitor in $monitors; do
	xrandr --output "$monitor" --brightness 0.5
done
sleep 20

notify-send -u critical "SHUTDOWN NOTICE" "10 Seconds until shutting everything down"
sleep 10

systemctl poweroff
