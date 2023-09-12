#!/usr/bin/env bash

source "${0%/*}/../source.sh"


cd ~/.dotfiles/os/unix/vendor

if [ ! -d 'dotdrop' ]; then
    git submodule add https://github.com/deadc0de6/dotdrop
fi
cd dotdrop

if [ ! -d './venv' ]; then
    python3 -m venv './venv'
    source './venv/bin/activate'
    python3 -m pip install -r './requirements.txt'
fi

cat <<"EOF" > ~/.dotfiles/.data/bin/dotdrop
#!/usr/bin/env sh
set -e
dotdrop_dir="$HOME/.dotfiles/os/unix/vendor/dotdrop"
. "$dotdrop_dir/venv/bin/activate"
"$dotdrop_dir/dotdrop.sh" "$@"
EOF
chmod +x ~/.dotfiles/.data/bin/dotdrop