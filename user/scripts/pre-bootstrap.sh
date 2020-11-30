#!/usr/bin/env sh

set -eu

export XDG_DATA_HOME="$HOME/data"
export XDG_CONFIG_HOME="$HOME/config"
export XDG_CACHE_HOME="$HOME/.cache"
export LANG="${LANG:-en_US.UTF-8}"
export LC_ALL="${LC_ALL:-en_US.UTF-8}"

export GOPATH="$XDG_DATA_HOME/go-path"
PATH="$HOME/.go/bin:$PATH"
PATH="$GOPATH/bin:$PATH"

must() {
    echo "Error: '$1' not installed. Exiting" >&2
    exit 1
}

cleanup() {
    rm ~/.gitconfig
}

## start ##
{
    type git || must git
    type cat || must cat
    type sudo || must sudo
    type tee || must tee
    type mount || must mount
    type go || must go
} >/dev/null

cat > ~/.gitconfig <<EOF
[user]
	name = Edwin Kofler
	email = 24364012+eankeen@users.noreply.github.com
EOF

sudo tee --append /etc/fstab >/dev/null <<EOF
# XDG Desktop Entries
/dev/fox/stg.files  /storage/edwin  xfs  defaults,relatime,X-mount.mkdir=0755  0  2
/storage/edwin/Music  /home/edwin/Music  none  x-systemd.after=/data/edwin,X-mount.mkdir,bind,nofail  0  0
/storage/edwin/Pics  /home/edwin/Pics  none  x-systemd.after=/data/edwin,X-mount.mkdir,bind,nofail  0  0
/storage/edwin/Vids  /home/edwin/Vids  none  x-systemd.after=/data/edwin,X-mount.mkdir,bind,nofail  0  0
/storage/edwin/Dls  /home/edwin/Dls  none  x-systemd.after=/data/edwin,X-mount.mkdir,bind,nofail  0  0
/storage/edwin/Docs  /home/edwin/Docs  none  x-systemd.after=/data/edwin,X-mount.mkdir,bind,nofail  0  0

# Data Bind Mounts
/dev/fox/stg.data  /storage/data  reiserfs defaults,X-mount.mkdir  0 0
/storage/data/calcurse  /home/edwin/data/calcurse  none  x-systemd.after=/storage/data,X-mount.mkdir,bind,nofail  0 0
/storage/data/gnupg  /home/edwin/data/gnupg  none  x-systemd.after=/storage/data,X-mount.mkdir,bind,nofail  0 0
/storage/data/fonts  /home/edwin/data/fonts  none x-systemd.after=/storage/data,X-mount.mkdir,bind,nofail  0 0
/storage/data/BraveSoftware /home/edwin/config/BraveSoftware  none x-systemd.after=/storage/data,X-mount.mkdir,bind,nofail  0 0
/storage/data/ssh /home/edwin/.ssh  none x-systemd.after=/storage/data,X-mount.mkdir,bind,nofail  0 0
EOF

sudo mount -a

cd ~/Docs/Programming/repos/dotty
go install .

type dotty || {
    echo "Error: Dotty not found" >&2
    exit 1
}

git clone https://github.com/eankeen/dots ~/.dots

alias dotty='dotty --dotfiles-dir=$HOME/.dots'
dotty user apply

# install code
# install code plugins

mkdir ~/.old
for file in /etc/skel/* /etc/skel/.*; do
    file="$(echo "$file" | cut -c11- | awk 'length($0)>2')"
    [ -z "$file" ] && continue

    mv "$HOME/$file" ~/.old
done
echo "Info: Old dotfiles at ~/.old"

xrandr

cleanup
