# shellcheck shell=bash

if ! systemctl --user start lemonbar; then
	printf '%s\n' "Error: Could not start lemonbar"
fi
