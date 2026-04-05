# shellcheck shell=sh

# GENERAL.
# export NAME='Edwin Kofler'
# export EMAIL='edwin@kofler.com'
export BROWSER='librewolf'

export LANG="${LANG:-en_US.UTF-8}"
export LANGUAGE="${LANGUAGE:-"$LANG"}"
export LC_ALL="${LC_ALL:-"$LANG"}"
export EDITOR='nvim'
export VISUAL='nvim'
export DIFFPROG='vim -d'
export PAGER='less'
# export MANPAGER='vim +MANPAGER --not-a-term -u /dev/null -'
export MANPAGER='less'


# PROGRAM.
# Android
export ANDROID_HOME="$XDG_STATE_HOME/Android/Sdk"
_util_path_prepend "$ANDROID_HOME/tools"
_util_path_prepend "$ANDROID_HOME/tools/bin"
_util_path_prepend "$ANDROID_HOME/platform-tools"
export ANDROID_USER_HOME="$XDG_STATE_HOME/Android/User"

# bash-completion
export BASH_COMPLETION_USER_DIR="$XDG_CONFIG_HOME/bash"
export BASH_COMPLETION_USER_FILE="$XDG_CONFIG_HOME/bash/bash_completion.sh"

# fzf
export FZF_DEFAULT_COMMAND='ag --nocolor -g ""'
export FZF_DEFAULT_OPTS="--history \"$XDG_STATE_HOME/history/fzf_history\" --history-size=10000"

# gnupg
# export GPG_TTY; GPG_TTY=$(tty)

# Homebrew
export HOMEBREW_NO_ENV_HINTS=1

# hstr
export HSTR_CONFIG='hicolor'

# less
# shellcheck disable=SC3003
{
	export LESSKEYIN="$XDG_CONFIG_HOME/less/lesskey"
	export LESS_TERMCAP_mb=$'\e[1;31m' # Start blink.
	export LESS_TERMCAP_md=$'\e[1;36m' # Start bold.
	export LESS_TERMCAP_me=$'\e[0m' # End all.
	export LESS_TERMCAP_so=$'\e[01;44;33m' # Start reverse video.
	export LESS_TERMCAP_se=$'\e[0m' # End reverse video.
	export LESS_TERMCAP_us=$'\e[1;32m' # Start underline.
	export LESS_TERMCAP_ue=$'\e[0m' # End underline.
	export LESS_TERMCAP_us=$'\e[1;32m' # Start underline.
}

# more
export MORE='-l'

# nnn
export NNN_FALLBACK_OPENER='xdg-open'
export NNN_DE_FILE_MANAGER='nautilus'

# pass
export PASSWORD_STORE_DIR="$XDG_DATA_HOME/password-store"
export PASSWORD_STORE_CLIP_TIME='15'
export PASSWORD_STORE_ENABLE_EXTENSIONS='true'
export PASSWORD_STORE_GENERATED_LENGTH='40'

# Perl
export PERL_LOCAL_LIB_ROOT="$XDG_DATA_HOME/perl5"
export PERL_MB_OPT="--install_base \"$PERL_LOCAL_LIB_ROOT\""
export PERL_MM_OPT="INSTALL_BASE=\"$PERL_LOCAL_LIB_ROOT\""
_util_path_prepend "$PERL_LOCAL_LIB_ROOT/bin"
_util_path_prepend PERL5LIB "$PERL_LOCAL_LIB_ROOT/lib/perl5"

# Poetry
_util_path_prepend "$XDG_DATA_HOME/pypoetry/bin"

# pipx
export PIPX_BIN_DIR="$XDG_STATE_HOME/pipx/bin"

# pnpm
export PNPM_HOME="$XDG_DATA_HOME/pnpm"
_util_path_prepend "$PNPM_HOME"

# ps
export CMD_ENV='linux'

# Python
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonrc.py"
export PYTHON_HISTORY="$XDG_STATE_HOME/history/python_history"

# ripgrep
export RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME/ripgrep/config"

# Rust
_util_path_prepend "${CARGO_HOME:-$HOME/.cargo}/bin"

# ssh
# export SSH_ASKPASS=/usr/bin/ksshaskpass
# export SSH_ASKPASS_REQUIRE=prefer
# unset SSH_AGENT_PID
# if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
#   export SSH_AUTH_SOCK=
#   SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
# fi

# sxhkd
export SXHKD_SHELL='/bin/sh'

# systemd
export SYSTEMD_PAGER="env LESSKEYIN=$XDG_CONFIG_HOME/less/lesskey-systemd less"
export SYSTEMD_PAGERSECURE=false

# vim
export VIMINIT="if has('nvim') | source $XDG_CONFIG_HOME/nvim/init.lua | else | source $XDG_CONFIG_HOME/vim/vimrc | endif"

# Wasmer
[ -f "${WASMER_DIR:-$HOME/.wasmer}/wasmer.sh" ] && . "${WASMER_DIR:-$HOME/.wasmer}/wasmer.sh"

# Wasmtime
_util_path_prepend "${WASMTIME_HOME:-$HOME/.wasmtime}/bin"

# Yarn
_util_path_prepend "$HOME/.yarn/bin"

# zsh
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# zinit
export ZINIT_HOME="$XDG_DATA_HOME/zinit/zinit.git"

# zfs
export ZFS_COLOR=1

# zplug
export ZPLUG_HOME="$HOME/.dotfiles/.data/repos/zplug"


# HISTORY.
# IRB
export IRBRC="$XDG_STATE_HOME/history/irbrc_history"

# GDB
export GDBHISTFILE="$XDG_STATE_HOME/history/gdb_history"

# GNU Octave
export OCTAVE_HISTFILE="$XDG_STATE_HOME/history/octave-history"

# Guile
export GUILE_HISTORY="$XDG_STATE_HOME/history/guile_history"

# Julia
export JULIA_HISTORY="$XDG_STATE_HOME/history/julia_history"

# MySQL
export MYSQL_HISTFILE="$XDG_STATE_HOME/history/mysql_history"

# Node.js
export NODE_REPL_HISTORY="$XDG_STATE_HOME/history/node_repl_history"
export TS_NODE_HISTORY="$XDG_STATE_HOME/history/ts_node_repl_history"

# PostgreSQL
export PSQL_HISTORY="$XDG_STATE_HOME/history/psql_history"

# Redis
export REDISCLI_HISTFILE="$XDG_STATE_HOME/history/redis_history"

# rlwrap
export RLWRAP_HOME="$XDG_STATE_HOME/history"

# SQLite
export SQLITE_HISTORY="$XDG_STATE_HOME/history/sqlite_history"
