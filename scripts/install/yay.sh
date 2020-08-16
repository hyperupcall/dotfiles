#!/bin/sh -eu

git clone https://aur.archlinux.org/yay.git "$(mktemp -d)"
cd "$_"
makepkg -si
