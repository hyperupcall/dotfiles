#!/usr/bin/env bash

setD6vcp() {
	for n in $(ddcutil detect | awk '{ if ($1 == "I2C") { print $3 } }' | cut -d- -f2); do
		ddcutil --bus="$n" setvcp D6 "$1" &
	done
}

setD6vcp 5
wait

trap 'setD6vcp 0' INT

read -r
