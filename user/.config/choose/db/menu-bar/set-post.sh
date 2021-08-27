# shellcheck shell=sh

# TODO: TOML configuration for automatic launching after setting, removing previous ones with kill, etc.

categoryDir="$1"
program="$2"

echo a
. "$categoryDir/$program/launch.sh"
