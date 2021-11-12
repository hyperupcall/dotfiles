# shellcheck shell=bash

if command -v apt &>/dev/null; then
    sudo apt -y update
    sudo apt -y upgrade
    sudo apt -y install libssl-dev
elif command -v dnf &>/dev/null; then
    sudo dnf -y update
    sudo dnf -y upgrade
    sudo dnf -y install openssl-devel
fi

dotmgr module rust
cargo install starship

basalt global add hyperupcall/choose hyperupcall/autoenv hyperupcall/dotshellextract hyperupcall/dotshellgen
basalt global add cykerway/complete-alias rcaloras/bash-preexec

# TODO
# - ssh keys
# - gpg keys
# - symlinking, /storage/ur mounting, if applicable
# --- in ~/.bashrc, etc.