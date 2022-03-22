# shellcheck shell=sh

categoryDir="$1"
program="$2"

echo a
. "$categoryDir/$program/launch.sh"
