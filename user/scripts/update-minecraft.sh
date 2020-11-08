#!/bin/sh

cd "$(mktemp -d)"
curl -sSLO https://launcher.mojang.com/download/Minecraft.deb
sudo dpkg -i ./Minecraft.deb
sudo apt-get install -f

