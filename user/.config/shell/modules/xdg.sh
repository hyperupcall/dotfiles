# shellcheck shell=sh

# aspell
export ASPELL_CONF="per-conf $XDG_CONFIG_HOME/aspell/aspell.conf; personal $XDG_CONFIG_HOME/aspell/en.pws; repl $XDG_CONFIG_HOME/aspell/en.prepl"

# asdf
export ASDF_DATA_DIR="$XDG_DATA_HOME/asdf"
export ASDF_DIR="$XDG_DATA_HOME/asdf"
export ASDF_CONFIG_FILE="$XDG_CONFIG_HOME/asdf/asdfrc"
export ASDF_DEFAULT_TOOL_VERSIONS_FILENAME="$XDG_CONFIG_HOME/asdf/tool-versions"
_path_prepend "$ASDF_DIR/bin"
_path_prepend "$ASDF_DATA_DIR/shims"

# android
export ANDROID_SDK_ROOT="$XDG_DATA_HOME/Android/sdk"
export ANDROID_EMULATOR_HOME="$XDG_DATA_HOME/Android/emulator"
export ANDROID_AVD_HOME="$XDG_DATA_HOME/Android/avd"

# atom
export ATOM_HOME="$XDG_DATA_HOME/atom"

# autoenv
export AUTOENV_AUTH_FILE="$XDG_DATA_HOME/autoenv/auth_file"

# aws
export AWS_SHARED_CREDENTIALS_FILE="$XDG_DATA_HOME/aws/credentials"
export AWS_CONFIG_FILE="$XDG_DATA_HOME/aws/config"

# azure
export AZURE_CONFIG_DIR="$XDG_DATA_HOME/azure"

# babel
export BABEL_CACHE_PATH="$XDG_CACHE_HOME/babel.json"

# bash-completion
export BASH_COMPLETION_USER_DIR="$XDG_CONFIG_HOME/bash"
export BASH_COMPLETION_USER_FILE="$XDG_CONFIG_HOME/bash/bash_completion.sh"

# bashmarks
SDIRS="$XDG_DATA_HOME/bashmarks.sh.db"

# boto
export BOTO_CONFIG="$XDG_DATA_HOME/boto"

# brew
export HOMEBREW_NO_ANALYTICS=1

# bundle
export BUNDLE_USER_CONFIG="$XDG_CONFIG_HOME/bundle"
export BUNDLE_USER_CACHE="$XDG_CACHE_HOME/bundle"
export BUNDLE_USER_PLUGIN="$XDG_DATA_HOME/bundle"

# cabal
export CABAL_CONFIG="$XDG_CONFIG_HOME/cabal/config"
export CABAL_DIR="$XDG_DATA_HOME/cabal"
_path_prepend "$CABAL_DIR/bin"

# ccache
export CCACHE_DIR="$XDG_CACHE_HOME/ccache"
export CCACHE_CONFIGPATH="$XDG_CONFIG_HOME/ccache/config"

# cinelerra
export CIN_CONFIG="$XDG_CONFIG_HOME/bcast5"

# conda
export CONDA_ROOT="$XDG_CONFIG_HOME/conda"
# _path_prepend "$XDG_DATA_HOME/miniconda3/bin"

# cookiecutter
export COOKIECUTTER_CONFIG="$XDG_CONFIG_HOME/cookiecutter/cookiecutterrc"

# crenv
# export CRENV_ROOT="$XDG_DATA_HOME/crenv"
# _path_prepend "$CRENV_ROOT/bin"

# cpanm
export PERL_CPANM_HOME="$XDG_DATA_HOME/cpanm"

# crawl
export CRAWL_DIR="$XDG_DATA_HOME/crawl/" # trailing slash required

# cuda
export CUDA_CACHE_PATH="$XDG_CACHE_HOME/nv"

# curl
export CURL_HOME="$XDG_CONFIG_HOME/curl"

# dart
export PUB_CACHE="$XDG_CACHE_HOME/pub-cache"

# deno
export DENO_INSTALL="$XDG_DATA_HOME/deno"
export DENO_INSTALL_ROOT="$DENO_INSTALL/bin"
export DVM_DIR="$XDG_DATA_HOME/dvm"
_path_prepend "$DENO_INSTALL_ROOT"
_path_prepend "$DENO_INSTALL_ROOT/bin"
_path_prepend "$DVM_DIR/bin"

# docker
export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"

# docker-machine
export MACHINE_STORAGE_PATH="$XDG_DATA_HOME/docker-machine"

# duc
export DUC_DATABASE="$XDG_DATA_HOME/duc.db"

# dvdcss
export DVDCSS_CACHE="$XDG_CACHE_HOME"/dvdcss

# electrum
export ELECTRUMDIR="$XDG_DATA_HOME/electrum"

# elinks
export ELINKS_CONFDIR="$XDG_CONFIG_HOME/elinks"

# emscripten
export EM_CONFIG="$XDG_CONFIG_HOME/emscripten/config"
export EM_CACHE="$XDG_CACHE_HOME/emscripten/cache"
export EM_PORTS="$XDG_DATA_HOME/emscripten/cache"

# g
export GOPATH="$XDG_DATA_HOME/go-path"
export GOROOT="$XDG_DATA_HOME/go-root"
_path_prepend "$GOPATH/bin"

# gdb
export GDBHISTFILE="$XDG_STATE_HOME/history/history"

# gem
export GEM_HOME="$XDG_DATA_HOME/gem" # conflicts with rvm
export GEM_SPEC_CACHE="$XDG_CACHE_HOME/gem"
_path_prepend "$GEM_HOME/bin"
# _path_prepend "$HOME/.gem/ruby/2.7.0/bin"

# get_iplayer
export GETIPLAYERUSERPREFS="$XDG_DATA_HOME/get_iplayer"

# ghcup (haskell)
export GHCUP_INSTALL_BASE_PREFIX="$XDG_DATA_HOME/ghcup"
_path_prepend "$GHCUP_INSTALL_BASE_PREFIX/bin" # requires symlink

# gitlib
export GITLIBS="$XDG_DATA_HOME/gitlibs"

# gnustep
export GNUSTEP_USER_ROOT="$XDG_DATA_HOME/GNUstep"

# gpodder
export GPODDER_HOME="$XDG_DATA_HOME/gPodder"

# gq
export GQRC="$XDG_CONFIG_HOME/gqrc"
export GQSTATE="$XDG_DATA_HOME/gq/gq-state"

# gradle
export GRADLE_USER_HOME="$XDG_DATA_HOME/gradle"

# grip
export GRIPHOME="$XDG_CONFIG_HOME/grip"

# gtk
export GTK_RC_FILES="$XDG_CONFIG_HOME/gtk-1.0/gtkrc"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"

# hledger
export LEDGER_FILE="$XDG_STATE_HOME/hledger/hledger.journal"

# ice authority
# export ICEAUTHORITY="$XDG_RUNTIME_DIR/iceauthority" # XDG_RUNTIME_DIR bad

# ida
export IDAUSR="$XDG_STATE_HOME/idapro"

# imap
export IMAPFILTER_HOME="$XDG_CONFIG_HOME/imapfilter"

# info
alias info='info --init-file $XDG_CONFIG_HOME/info/infokey'

# ipfs
export IPFS_PATH="$XDG_DATA_HOME/ipfs"

# ipython
export IPYTHONDIR="$XDG_CONFIG_HOME/jupyter"

# irb
export IRBRC="$XDG_CONFIG_HOME/irb/irbrc"

# irssi
alias irssi='irssi --config "$XDG_CONFIG_HOME/irssi" --home "$XDG_CONFIG_HOME/irssi"'

# java
# export _JAVA_OPTIONS="-Djava.util.prefs.userRoot=$XDG_DATA_HOME/java"
export JAVA_TOOL_OPTIONS="-Djava.util.prefs.userRoot=$XDG_DATA_HOME/java"

# julia
export JULIA_DEPOT_PATH="$XDG_DATA_HOME/julia:$JULIA_DEPOT_PATH"
export JULIA_HISTORY="$XDG_STATE_HOME/history/julia_history"

# junest
export JUNEST_HOME="$XDG_DATA_HOME/junest"

# jupyter
export JUPYTER_CONFIG_DIR="$XDG_CONFIG_HOME/jupyter"

# k9s
export K9SCONFIG="$XDG_CONFIG_HOME/k9s"

# kde
export KDEHOME="$XDG_CONFIG_HOME/kde"

# krew
export KREW_ROOT="$XDG_DATA_HOME/krew"
_path_prepend "$KREW_ROOT/bin"

# ldap
# export LDAPRC="$XDG_CONFIG_HOME/ldap.conf"

# leiningen
export LEIN_HOME="$XDG_DATA_HOME/lein"

# ltrace
alias ltrace='ltrace -F "$XDG_CONFIG_HOME/ltrace/ltrace.conf"'

# maven
alias mvn='mvn -gs "$XDG_CONFIG_HOME/maven/settings.xml"'

# maxima
export MAXIMA_USERDIR="$XDG_CONFIG_HOME/maxima"

#
export MBSYNC_CONFIG="$XDG_CONFIG_HOME/mbsync/config"

# mednafen
export MEDNAFEN_HOME="$XDG_CONFIG_HOME/mednafen"

# mongo
alias mongo='mongo --norc'

# most
export MOST_INITFILE="$XDG_CONFIG_HOME/most/mostrc"

# mplayer
export MPLAYER_HOME="$XDG_DATA_HOME/mplayer"

# mysql
export MYSQL_HISTFILE="$XDG_STATE_HOME/history/mysql_history"

# n
export N_PREFIX="$XDG_DATA_HOME/n"
_path_prepend "$N_PREFIX/bin"

# nb
export NBRC_PATH="$XDG_CONFIG_HOME/nb/nbrc"
export NB_DIR="$XDG_DATA_HOME/nb"
export NB_HIST="$XDG_STATE_HOME/history/nb_history"

# nimble
export CHOOSENIM_NO_ANALYTICS="1"
_path_prepend "$XDG_DATA_HOME/nimble/bin"

# node
export NODE_REPL_HISTORY="$XDG_STATE_HOME/history/node_repl_history"
export TS_NODE_HISTORY="$XDG_STATE_HOME/history/ts_node_repl_history"

# notmuch
export NOTMUCH_CONFIG="$XDG_CONFIG_HOME/notmuch/notmuchrc"
export NMBGIT="$XDG_DATA_HOME/notmuch/nmbug"

# npm
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"

# nuget
export NUGET_PACKAGES="$XDG_DATA_HOME/nuget/packages"

# nvidia
# alias nvidia-settings='nvidia-settings --config $XDG_DATA_HOME/nvidia-settings'

# nvm
export NVM_DIR="$XDG_DATA_HOME/nvm"

# octave
export OCTAVE_SITE_INITFILE="$XDG_CONFIG_HOME/octave/octaverc"
export OCTAVE_HISTFILE="$XDG_STATE_HOME/history/octave-history"

# openssl
# export RANDFILE="$XDG_DATA_HOME/openssl/rnd"

# opera
export OPERA_PERSONALDIR="$XDG_DATA_HOME/opera"

# packer
export PACKER_CONFIG="$XDG_DATA_HOME/packer/packerconfig"
export PACKER_CONFIG_DIR="$XDG_DATA_HOME/packer/packer.d"

# parallel
export PARALLEL_HOME="$XDG_CONFIG_HOME/parallel"

# pass
export PASSWORD_STORE_DIR="$XDG_DATA_HOME/password-store"

# perl
export PERL_LOCAL_LIB_ROOT="$XDG_DATA_HOME/perl5"
export PERL_MB_OPT="--install_base \"$PERL_LOCAL_LIB_ROOT\""
export PERL_MM_OPT="INSTALL_BASE=\"$PERL_LOCAL_LIB_ROOT\""
_path_prepend "$PERL_LOCAL_LIB_ROOT/bin"
_path_prepend PERL5LIB "$PERL_LOCAL_LIB_ROOT/lib/perl5"

# phpbrew
_path_prepend "$XDG_DATA_HOME/phpenv/bin"

# phpenv
export PHPENV_ROOT="$XDG_DATA_HOME/phpenv"
_path_prepend  "$PHPENV_ROOT/bin"

# plenv
export PLENV_ROOT="$XDG_DATA_HOME/plenv"
_path_prepend "$XDG_DATA_HOME/plenv/bin"

# poetry
export POETRY_HOME="$XDG_DATA_HOME/poetry"
_path_prepend "$POETRY_HOME/bin"

# postgresql
export PSQLRC="$XDG_DATA_HOME/pg/psqlrc"
export PSQL_HISTORY="$XDG_STATE_HOME/history/psql_history"
export PGPASSFILE="$XDG_DATA_HOME/pg/pgpass"
export PGSERVICEFILE="$XDG_DATA_HOME/pg/pg_service.conf"

# pulse
export PULSE_COOKIE="$XDG_DATA_HOME/pulse/cookie"

# pyenv
export PYENV_ROOT="$XDG_DATA_HOME/pyenv"
# _path_prepend "$PYENV_ROOT/bin"
# _path_prepend "$PYENV_ROOT/shims"

# pylint
export PYLINTHOME="$XDG_CACHE_HOME/pylint"
export PYLINTRC="$XDG_CONFIG_HOME/pylint/config"

# python
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonrc.py" # https://github.com/python/cpython/pull/13208
export PYTHON_EGG_CACHE="$XDG_CACHE_HOME/python-eggs"

# racket
export PLTUSERHOME="$XDG_DATA_HOME/racket"

# rbenv
export RBENV_ROOT="$XDG_DATA_HOME/rbenv"
_path_prepend "$RBENV_ROOT/bin"
_path_prepend "$RBENV_ROOT/shims"

# readline
export INPUTRC="$XDG_CONFIG_HOME/readline/inputrc"

# redix
export REDISCLI_RCFILE="$XDG_CONFIG_HOME/redis/redisclirc"
export REDISCLI_HISTFILE="$XDG_STATE_HOME/history/redis_history"

# ripgrep
export RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME/ripgrep/config"

# rlwrap
export RLWRAP_HOME="$XDG_STATE_HOME/history"

# rust
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
_path_prepend "$CARGO_HOME/bin"

# ruby-build
export RUBY_BUILD_CACHE_PATH="$XDG_CACHE_HOME/ruby-build"

# rvm
_path_prepend "$XDG_DATA_HOME/rvm/bin"
# TODO
[ -r "$XDG_DATA_HOME/rvm/scripts/rvm" ] && safe_source "$XDG_DATA_HOME/rvm/scripts/rvm"

# sage
export DOT_SAGE="$XDG_CONFIG_HOME/sage"

# sbt
alias sbt='sbt -ivy "$XDG_DATA_HOME/ivy2" -sbt-dir "$XDG_DATA_HOME/sbt"'

# sccache
export SCCACHE_CACHE_SIZE="100G"
export SCCACHE_DIR="$XDG_CACHE_HOME/sccache"

# screen
export SCREENRC="$XDG_CONFIG_HOME/screenrc"

# spacemacs
export SPACEMACSDIR="$XDG_CONFIG_HOME/spacemacs"

# subversion
alias svn='svn --config-dir "$XDG_CONFIG_HOME/subversion"'

# xsm
export SM_SAVE_DIR="$XDG_DATA_HOME/xsm"

# sonarlint
export SONARLINT_USER_HOME="$XDG_DATA_HOME/sonarlint"

# sqlite
export SQLITE_HISTORY="$XDG_STATE_HOME/history/sqlite_history"

# stack
export STACK_ROOT="$XDG_DATA_HOME/stack"

# starship
export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"

# subversion
export SUBVERSION_HOME="$XDG_CONFIG_HOME/subversion"

# swift
export SWIFTENV_ROOT="$XDG_DATA_HOME/swiftenv"
_path_prepend "$SWIFTENV_ROOT/bin"
# eval "$(swiftenv init -)"

# task
export TASKRC="$XDG_CONFIG_HOME/taskwarrior/taskrc"
export TASKDATA="$XDG_DATA_HOME/taskwarrior"

# terminfo
# export TERMINFO="$XDG_DATA_HOME"/terminfo
# export TERMINFO_DIRS="$XDG_DATA_HOME"/terminfo:/usr/share/terminfo

# texmf
export TEXMFHOME="$XDG_DATA_HOME/textmf"

# todotxt
export TODOTXT_CFG_FILE="$XDG_CONFIG_HOME/todotxt/config.sh"

# tmux
alias tmux='tmux -f "$XDG_CONFIG_HOME/tmux/tmux.conf"'
export TMUX_TMPDIR="$XDG_RUNTIME_DIR"

# tree-sitter
export TREE_SITTER_DIR="$XDG_CONFIG_HOME/tree-sitter"

# ts3
export TS3_CONFIG_DIR="$XDG_CONFIG_HOME/ts3client"

# uncrustify
export UNCRUSTIFY_CONFIG="$XDG_CONFIG_HOME/uncrustify/uncrustify.cfg"

# unison
export UNISON="$XDG_DATA_HOME/unison"

# vagrant
export VAGRANT_HOME="$XDG_DATA_HOME/vagrant"
export VAGRANT_ALIAS_FILE="$VAGRANT_HOME/aliases"

# vim
export VIMINIT="if has('nvim') | let \$MYVIMRC=\$XDG_CONFIG_HOME.\"/nvim/init.vim\" | else | let \$MYVIMRC=\$XDG_CONFIG_HOME.\"/vim/vimrc\" | endif | source \$MYVIMRC"

# vimperator
export VIMPERATOR_INIT=":source $XDG_CONFIG_HOME/vimperator/vimperatorrc"
export VIMPERATOR_RUNTIME="$XDG_CONFIG_HOME/vimperator"

# urxvt
export URXVT_PERL_LIB="$XDG_CONFIG_HOME/urxvt/ext"
export RXVT_SOCKET="$XDG_RUNTIME_DIR"/urxvtd

# wakatime
export WAKATIME_HOME="$XDG_DATA_HOME/wakatime"

# wasmer
export WASMER_DIR="$XDG_DATA_HOME/wasmer"
# [ -r "$WASMER_DIR/wasmer.sh" ] && source "$WASMER_DIR/wasmer.sh"

# wasmtime
export WASMTIME_HOME="$XDG_DATA_HOME/wasmtime"
_path_prepend "$WASMTIME_HOME/bin"

# wget
export WGETRC="$XDG_CONFIG_HOME/wget/wgetrc"

# wine
export WINEPREFIX="$XDG_DATA_HOME/wine"
# wine winecfg

# wolfram mathematica
export MATHEMATICA_BASE="/usr/share/mathematica"
export MATHEMATICA_USERBASE="$XDG_DATA_HOME/mathematica"

# X11
#export XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority"
#export XCOMPOSEFILE="$XDG_CONFIG_HOME/X11/Xcompose"
#export XCOMPOSECACHE="$XDG_CACHE_HOME/X11/Xcompose"

# xsel
alias xsel='xsel -l "$XDG_DATA_HOME/xsel/xsel.log'

# yarn
export YARN_CACHE_FOLDER="$XDG_CACHE_HOME/yarn"
_path_prepend "$XDG_DATA_HOME/yarn/bin"
alias yarn='yarn --use-yarnrc "$XDG_CONFIG_HOME/yarn/config"'

# z
export _Z_DATA="$XDG_DATA_HOME/z"
