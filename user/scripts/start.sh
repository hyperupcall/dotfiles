#!/bin/sh

ln -s ~/Docs/programming/repos ~/repos
ln -s ~/Docs/programming/projects ~/projects

mkdir ~/.hidden
mkdir ~/.history
mkdir -p ~/.local/opt/go/root
mkdir -p ~/.local/opt/go/path

mkdir ~/data/X11

mkdir ~/data/gnupg
# change permissions

ln -s ~/docs/programming/repos/ ~/repos
ln -s ~/docs/programming/projects ~/projects


ls ~/.lesshst
ls ~/.nv
# these keep occuring

rm ~/.dbshell

# if these exist, there is a problem

ls ~/.bash_history
xsetroot -xcf /usr/share/icons/whiteglass/cursors/left_ptr 32


rm ~/yarn.lock
rm ~/node_modules

cargo install broot
cargo install just
cargo install starship
cargo install git-delta

pnpm i -g diff-so-fancy
