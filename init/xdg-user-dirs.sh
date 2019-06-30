#!/bin/bash

# remove old folders
rmdir $HOME/Desktop
rmdir $HOME/Downloads
rmdir $HOME/Templates
rmdir $HOME/Public
rmdir $HOME/Documents
rmdir $HOME/Music
rmdir $HOME/Pictures
rmdir $HOME/Videos

# create new foldesr
mkdir $HOME/desk
mkdir $HOME/dls
mkdir $HOME/templates
mkdir $HOME/public
mkdir $HOME/docs
mkdir $HOME/music
mkdir $HOME/pics
mkdir $HOME/vids

# set the new folders
xdg-user-dirs-update --set DESKTOP $HOME/desk
xdg-user-dirs-update --set DOWNLOAD $HOME/dls
xdg-user-dirs-update --set TEMPLATES $HOME/templates
xdg-user-dirs-update --set PUBLICSHARE $HOME/public
xdg-user-dirs-update --set DOCUMENTS $HOME/docs
xdg-user-dirs-update --set MUSIC $HOME/music
xdg-user-dirs-update --set PICTURES $HOME/pics
xdg-user-dirs-update --set VIDEOS $HOME/vids

# blueman bluetooth services will complain since the 'downloads' directory changed
gsettings set org.blueman.transfer shared-path "$HOME/dls"

# creates and updates folders
xdg-user-dirs-update

