# shellcheck shell=sh

# bm
export BM_SRC="$HOME/Docs/Programming/repos/bm"
alias bm='~/repos/bm/bm.sh'
path_add_pre "$XDG_DATA_HOME/bm/bin"

# snap
#export PATH="/snap/bin:$PATH"
path_add_post "/var/lib/snapd/snap/bin"

# hstr
export HSTR_CONFIG=hicolor
