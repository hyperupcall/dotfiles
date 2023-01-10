
# BRIGHTNESS DECREASE

ddci() {
	#!/usr/bin/env sh

for n in $(ddcutil detect | awk '{ if ($1 == "I2C") { print $3 } }' | cut -d- -f2); do
	ddcutil --bus="$n" setvcp 10 50 &
done

wait

}

x11() {
	#!/usr/bin/env sh

for monitor in $(xrandr --listactivemonitors | awk '{ print $4 }' | xargs); do
	xrandr --output "$monitor" --brightness 1 &
done

wait

}







## increase
ddci() {
	#!/usr/bin/env sh

for n in $(ddcutil detect | awk '{ if ($1 == "I2C") { print $3 } }' | cut -d- -f2); do
	ddcutil --bus="$n" setvcp 10 150 &
done

wait
}
x11() {
	#!/usr/bin/env sh

for monitor in $(xrandr --listactivemonitors | awk '{ print $4 }' | xargs); do
	xrandr --output "$monitor" --brightness 4 &
done

wait

}




# reset

ddcci() {

#!/usr/bin/env sh

for n in $(ddcutil detect | awk '{ if ($1 == "I2C") { print $3 } }' | cut -d- -f2); do
	ddcutil --bus="$n" setvcp 10 150 &
done

wait
}
x11() {
#!/usr/bin/env sh

for monitor in $(xrandr --listactivemonitors | awk '{ print $4 }' | xargs); do
	xrandr --output "$monitor" --brightness 1 &
done

wait

}



# SONG NEXt
cmus() {
	#!/usr/bin/env sh

cmus-remote --next

}


# VOLUME MUTE
alsa() {
	#!/usr/bin/env sh

amixer -q set Master toggle

}
pulse() {
	#!/usr/bin/env sh

pactl set-sink-mute @DEFAULT_SINK@ toggle
killall -SIGUSR1 i3status

pamixer --get-volume > "$XDG_RUNTIME_DIR/xob.sock"

}


# VOLUME RAISE
alsa() {
	#!/usr/bin/env sh

amixer -q set Master 5%+

}
pulse() {
	#!/usr/bin/env sh

pactl set-sink-volume @DEFAULT_SINK@ +10%
killall -SIGUSR1 i3status

pamixer --get-volume > "$XDG_RUNTIME_DIR/xob.sock"

}
