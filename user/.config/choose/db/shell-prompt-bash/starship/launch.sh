# shellcheck shell=bash

str=$(starship init bash --print-full-init)
printf "%s" "$str"
