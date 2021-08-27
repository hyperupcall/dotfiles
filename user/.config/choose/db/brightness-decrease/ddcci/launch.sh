#!/usr/bin/env sh

for n in $(ddcutil detect | awk '{ if ($1 == "I2C") { print $3 } }' | cut -d- -f2); do
	ddcutil --bus="$n" setvcp 10 50 &
done

wait
