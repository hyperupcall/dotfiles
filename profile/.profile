
#!/bin/sh

# general
export VISUAL="nvim"
export EDITOR="$VISUAL"
export PAGER="less"
export SUDO_EDITOR="nvim"

# xdg
export XDG_DATA_HOME="$HOME/.local/share" # default
export XDG_CONFIG_HOME="$HOME/.config" # defualt
export XDG_DATA_DIRS="/usr/local/share/:/usr/share" # default
export XDG_CONFIG_DIRS="/etc/xdg" # default
export XDG_CACHE_HOME="$HOME/.cache" # default
#      XDG_RUNTIME_DIR # set by pam_systemd

# vim (github.com/vim/vim)
export VIMINIT="source "$XDG_CONFIG_HOME/vim/vimrc""

# npm (github.com/npm/cli)
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npmrc"

# n (github.com/tj/n)
# will not install to $HOME/.local directly (actual install in ~/.local/n/n)
export N_PREFIX="$HOME/.local/n"
export PATH="$N_PREFIX/bin:$PATH"

# nvm (github.com/nvm-sh/nvm)
# export NVM_DIR="$HOME/.config/nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # loads nvm bash_completion

# yarn (github.com/yarnpkg/yarn)
export YARN_CACHE_FOLDER="$XDG_CACHE_HOME/yarn"
export PATH="$XDG_DATA_HOME/yarn/global/node_modules/.bin:$PATH"

# less
export LESSHISTFILE="$XDG_DATA_HOME/lesshst"
export LESSHISTSIZE="250"

# gnupg (git.gnupg.org/cgi-bin/gitweb.cgi)
export GNUPGHOME="$XDG_DATA_HOME/gnupg"

# poetry (github.com/sdispater/poetry)
export PATH="$HOME/.poetry/bin:$PATH"

# rust (github.com/rust-lang/rust)
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export PATH="$HOME/.local/share/.cargo/bin:$PATH"

# sccache (github.com/mozilla/sccache)
export SCCACHE_CACHE_SIZE="20G"
export SCCACHE_DIR="$XDG_CACHE_HOME/sccache"

# snap
export PATH="/snap/bin:$PATH"

# wolfram mathematica
export MATHEMATICA_BASE="/usr/share/mathematica"
export MATHEMATICA_USERBASE="$HOME/.local/share/mathematica"

# terraform (github.com/hashicorp/terraform)
export TF_CLI_CONFIG_FILE="$XDG_CONFIG_HOME/terraformrc-custom"

# nnn (github.com/jarun/nnn)
export NNN_FALLBACK_OPENER="xdg-open"
export NNN_DE_FILE_MANAGER="nautilus"

# microk8s (github.com/ubuntu/microk8s)
alias kubectl="microk8s.kubectl"

# path
export PATH="$HOME/.local/bin:$PATH"

#tty -s
#if test $? -eq 0
#then
#  echo test
#setfont /usr/share/kbd/consolefonts/ter-132n.psf.gz
#fi
export GPG_TTY=$(tty)
alias b='buku --suggest'

# the next line updates PATH for the Google Cloud SDK.
if [ -f '/home/edwin/.local/google-cloud-sdk/path.bash.inc' ]; then . '/home/edwin/.local/google-cloud-sdk/path.bash.inc'; fi

# the next line enables shell command completion for gcloud.
if [ -f '/home/edwin/.local/google-cloud-sdk/completion.bash.inc' ]; then . '/home/edwin/.local/google-cloud-sdk/completion.bash.inc'; fi
