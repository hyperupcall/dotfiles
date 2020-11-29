#
# ~/.profile
#

# ----------------------- Functions ---------------------- #
path_add_pre() {
	[ -d "$1" ] || return

	case ":$PATH:" in
		*":$1:"*) :;;
		*) export PATH="$1:$PATH" ;;
	esac
}

path_add_post() {
	[ -d "$1" ] || return

	case ":$PATH:" in
		*":$1:"*) :;;
		*) export PATH="$PATH:$1" ;;
	esac
}


# ------------------------ Common ------------------------ #
export XDG_DATA_HOME="$HOME/data"
export XDG_CONFIG_HOME="$HOME/config"
export XDG_CACHE_HOME="$HOME/.cache"

export LANG="${LANG:-en_US.UTF-8}"
export LANGUAGE="$LANG"
export LC_ALL="${LC_ALL:-en_US.UTF-8}"
export VISUAL="vim"
export EDITOR="$VISUAL"
export DIFFPROG="nvim -d"
export PAGER="less"
export MANPAGER="less -X"
export BROWSER="brave-browser"
export SPELL="aspell -x -c"
export CMD_ENV="linux"

umask 022


# ------------------------ Custom ------------------------ #
SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
export SSH_AUTH_SOCK

path_add_pre "$HOME/scripts/"
path_add_pre "$HOME/.local/bin"
path_add_pre "$HOME/bin"

alias cliflix='cliflix -- --no-quit --vlc'
alias g='git'
alias j=just
alias la='exa -a'
alias ll='exa -al'
alias mkdir='mkdir -p'
alias ping='ping -c 5'
alias psa='ps xawf -eo pid,user,cgroup,args'
alias r='trash-rm'
alias xz='xz -k'

lb() {
	lsblk -o NAME,FSTYPE,LABEL,FSUSED,FSAVAIL,FSSIZE,FSUSE%,MOUNTPOINT
}

mkt() {
	dir="$(mktemp -d)"

	[ -n "$1" ] && {
		mv "$1" "$dir"
		cd "$dir"
		return
	}

	cd "$dir"
}


mkc() {
	mkdir -- "$@" && cd -- "$@"
}

sp() {
	source ~/.profile
}

chr() {
	: ${1:?"Error: No mountpoint specified"}
	[ -d "$1" ] || { echo "Error: Folder doesn't exist"; exit 1; }

	sudo mount -o bind -t proc /proc/ "$1/proc"
	sudo mount -o bind -t sysfs /sys "$1/sys"
	sudo mount -o bind -t tmpfs /run "$1/run"
	sudo mount -o bind -t devtmpfs /dev "$1/dev"
}

doBackup() {
	restic --repo /storage/vault/rodinia/backups/ backup /storage/edwin/ --iexclude "node_modules" --iexclude "__pycache__" --iexclude "rootfs"
}

doBackup2() {
	restic --repo /storage/vault/rodinia/backups-data/ backup /storage/data/ --iexclude "node_modules" --iexclude "__pycache__" --iexclude "rootfs"
}

serv() {
	[ -d "${1:-.}" ] || { echo "Error: dir '$1' doesn't exist"; return 1; }
	python3 -m http.server --directory "${1:-.}" "${2:-4000}"
}

v() {
	if [ $# -eq 0 ]; then
		vim .
	else
		vim "$@"
	fi
}

o() {
	if [ $# -eq 0 ]; then
		xdg-open .
	else
		xdg-open "$@"
	fi
}

oimg() {
	local types='*.jpg *.JPG *.png *.PNG *.gif *.GIF *.jpeg *.JPEG'

	cd "$(dirname "$1")" || exit
	local file
	file=$(basename "$1")

	feh -q "$types" --auto-zoom \
		--sort filename --borderless \
		--scale-down --draw-filename \
		--image-bg black \
		--start-at "$file"
}

tre() {
	tree -a \
		-I '.git' -I '.svn' -I '.hg' \
		--ignore-case --matchdirs --filelimit \
		-h -F --dirsfirst -C "$@"
}

dg() {
	dig +nocmd "$1" any +multiline +noall +answer
}

tmpd() {
	[ $# -eq 0 ] && {
		# || return for shellcheck
		cd "$(mktemp -d)" || return
		return
	}

	cd "$(mktemp -d -t "${1}.XXXXXXXXXX")" || return
}

mkd() {
	mkdir -p "$@"
	cd "$@" || exit
}

dataurl() {
	mimeType=$(file -b --mime-type "$1")
	case "$mimeType" in
		text/*)
			mimeType="${mimeType};charset=utf-8"
		;;
	esac

	str="$(openssl base64 -in "$1" | tr -d '\n')"
	printf "data:${mimeType};base64,%s\n" "$str"

	unset -v mimeType
	unset -v str
}

utf8encode() {
	mapfile -t args < <(printf "%s" "$*" | xxd -p -c1 -u)
	printf "\\\\x%s" "${args[@]}"

	# print newline if we're not piping to another program
	[ -t 1 ] && echo
}

utf8decode() {
	perl -e "binmode(STDOUT, ':utf8'); print \"$*\""

	# print newline if we're not piping to another program
	[ -t 1 ] && echo
}

codepoint() {
	perl -e "use utf8; print sprintf('U+%04X', ord(\"$*\"))"

	# print newline if we're not piping to another program
	[ -t 1 ] && echo
}

isup() {
	curl -sS --head --X GET "$1" | grep "200 OK" >/dev/null
}

dbs() {
	dbus-send --"${1:-session}" \
		--dest=org.freedesktop.DBus \
		--type=method_call \
		--print-reply \
		/org/freedesktop/DBus org.freedesktop.DBus.ListNames
}


# ----------------- Program Configuration ---------------- #
alias b='bukdu --suggest'

# anki
alias anki='anki -b "$XDG_DATA_HOME/anki"'

# atom
export ATOM_HOME="$XDG_DATA_HOME/atom"

# aws
export AWS_SHARED_CREDENTIALS_FILE="$XDG_DATA_HOME/aws/credentials"
export AWS_CONFIG_FILE="$XDG_DATA_HOME/aws/config"

# bash-completeion
export BASH_COMPLETION_USER_FILE="$XDG_CONFIG_HOME/bash-completion/bash_completion"

# bm
alias bm='~/repos/bm/bm.sh'
path_add_pre "$XDG_DATA_HOME/bm/bin"

# boto
export BOTO_CONFIG="$XDG_DATA_HOME/boto"

# bundle
export BUNDLE_USER_HOME="$XDG_DATA_HOME/bundle"
export BUNDLE_CACHE_PATH="$XDG_CACHE_HOME/bundle"
export BUNDLE_USER_CACHE="$XDG_CACHE_HOME/bundle"
export BUNDLE_USER_PLUGIN="$XDG_DATA_HOME/bundle"

# ccache
export CCACHE_DIR="$XDG_CACHE_HOME/ccache"
export CCACHE_CONFIGPATH="$XDG_CONFIG_HOME/ccache/config"

# chmod
alias chmod='chmod --preserve-root'

# chown
alias chown='chown --preserve-root'

# cp
alias cp='cp -i'

# cuda
export CUDA_CACHE_PATH="$XDG_CACHE_HOME/nv"

# curl
alias curl='curl --config $XDG_CONFIG_HOME/curl/curlrc'

# dart
export PUB_CACHE="$XDG_CACHE_HOME/pub-cache"

# dd
alias dd='dd status=progress'

# deno
export DENO_INSTALL="$XDG_DATA_HOME/deno"
export DENO_INSTALL_ROOT="$DENO_INSTALL/bin"
path_add_pre "$DENO_INSTALL_ROOT"
path_add_pre "$DENO_INSTALL_ROOT/bin"

# diff
alias diff='diff --color=auto'

# dir
alias dir='dir --color=auto'

# df
alias df='df -h'

# docker
export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"

# du
alias du='du -h'

# dotty
alias dotty='dotty --dotfiles-dir=$HOME/.dots'

# egrep
alias egrep='egrep --colour=auto'

# elinks
export ELINKS_CONFDIR="$XDG_CONFIG_HOME/elinks"

# feh
alias feh='feh --no-fehbg'

# fgrep
alias fgrep='fgrep --colour=auto'

# free
alias free='free -m'

# g
export GOPATH="$XDG_DATA_HOME/go-path"
path_add_pre "$GOPATH/bin"

# gem
export GEM_HOME="$XDG_DATA_HOME/gem"
export GEM_SPEC_CACHE="$XDG_CACHE_HOME/gem"

# gitlib
export GITLIBS="$XDG_DATA_HOME/gitlibs"

# gnupg
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
GPG_TTY="$(tty)"
export GPG_TTY

# grep
alias grep='grep --colour=auto'

# git
export GIT_CONFIG_NOSYSTEM=

# gradle
export GRADLE_USER_HOME="$XDG_DATA_HOME/gradle"

# gtk
export GTK_RC_FILES="$XDG_CONFIG_HOME/gtk-1.0/gtkrc"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"

# gvm
# TODO: fix
export GVM_ROOT="$XDG_DATA_HOME/gvm"
export GVM_DEST="$GVM_ROOT"
test -x "$GVM_ROOT/scripts/gvm-default" && . "$GVM_ROOT/scripts/gvm-default"

# ice authority
export ICEAUTHORITY="$XDG_RUNTIME_DIR/iceauthority"

# imap
export IMAPFILTER_HOME="$XDG_CONFIG_HOME/imapfilter"

# ip
alias ip='ip -color=auto'

# info
alias info='info --init-file $XDG_CONFIG_HOME/info/infokey'

# ipython
export IPYTHONDIR="$XDG_CONFIG_HOME"/jupyter

# irssi
alias irssi='irssi --config "$XDG_CONFIG_HOME/irssi"'

# junest
export JUNEST_HOME="$XDG_DATA_HOME/junest"

# jupyter
export JUPYTER_CONFIG_DIR="$XDG_CONFIG_HOME/jupyter"

# kde
export KDEHOME="$XDG_CONFIG_HOME/kde"

# krew
export KREW_ROOT="$XDG_DATA_HOME/krew"
path_add_pre "$KREW_ROOT/bin"

# kubernetes
export KUBECONFIG="$XDG_DATA_HOME/kube"

# less
# adding X breaks mouse scrolling of pages
export LESS="-FIRQ"
# export LESS="-FIRX"
export LESSKEY="$XDG_CONFIG_HOME/less_keys"
export LESSHISTFILE="$HOME/.history/less_history"
export LESSHISTSIZE="32768"
LESS_TERMCAP_mb="$(printf '\e[1;31m')" # start blink
LESS_TERMCAP_md="$(printf '\e[1;36m')" # start bold
LESS_TERMCAP_me="$(printf '\e[0m')" # end all
LESS_TERMCAP_so="$(printf '\e[01;44;33m')" # start reverse video
LESS_TERMCAP_se="$(printf '\e[0m')" # end reverse video
LESS_TERMCAP_us="$(printf '\e[1;32m')" # start underline
LESS_TERMCAP_ue="$(printf '\e[0m')" # end underline
LESS_TERMCAP_us="$(printf '\e[1;32m')" # start underline
export LESS_TERMCAP_mb LESS_TERMCAP_md LESS_TERMCAP_me \
	LESS_TERMCAP_so LESS_TERMCAP_se LESS_TERMCAP_us \
	LESS_TERMCAP_ue LESS_TERMCAP_us

# ls
alias ls='ls --color=auto'

# ltrace
alias ltrace='ltrace -F "$XDG_CONFIG_HOME/ltrace/ltrace.conf"'

# maven
alias mvn='mvn -gs "$XDG_CONFIG_HOME/maven/settings.xml"'
mkdir -p "$XDG_DATA_HOME/maven"

# mongo
alias mongo='mongo --norc'

# more
export MORE="--silent"

# most
export MOST_INITFILE="$XDG_CONFIG_HOME/most/mostrc"

# mplayer
export MPLAYER_HOME="$XDG_DATA_HOME/mplayer"

# mysql
export MYSQL_HISTFILE="$HOME/.history/mysql_history"

# n
export N_PREFIX="$XDG_DATA_HOME/n"
path_add_pre "$N_PREFIX/bin"

# netbeams
# alias netbeams='netbeans --userdir "$XDG_CONFIG_HOME/netbeans"'

# nimble
export CHOOSENIM_NO_ANALYTICS="1"
alias nimble='nimble --choosenimDir="$XDG_DATA_HOME/choosenim"'
path_add_pre "$XDG_DATA_HOME/nimble/bin"

# nnn
export NNN_FALLBACK_OPENER="xdg-open"
export NNN_DE_FILE_MANAGER="nautilus"

# node
export NODE_REPL_HISTORY="$HOME/.history/node_repl_history"
export TS_NODE_HISTORY="$HOME/.history/ts_node_repl_history"

# npm / pnpm
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export NPM_CONFIG_CACHE="$XDG_CACHE_HOME/npm"
export NPM_CONFIG_STORE_DIR="$XDG_DATA_HOME/pnpm-store"

# nvidia
#alias nvidia-settings='nvidia-settings --config $XDG_DATA_HOME/nvidia-settings'

# nvm
export NVM_DIR="$XDG_DATA_HOME"/nvm

# packer
export PACKER_CONFIG="$XDG_DATA_HOME/packer/packerconfig"
export PACKER_CONFIG_DIR="$XDG_DATA_HOME/packer/packer.d"

# pacman
alias pacman='pacman --color=auto'

# phpbrew
path_add_pre "$XDG_DATA_HOME/phpenv/bin"

# phpenv
export PHPENV_ROOT="$XDG_DATA_HOME/phpenv"
path_add_pre  "$PHPENV_ROOT/bin"

# poetry
path_add_pre "$HOME/.poetry/bin"

# postgresql
export PSQLRC="$XDG_DATA_HOME/pg/psqlrc"
export PSQL_HISTORY="$HOME/.history/psql_history"
export PGPASSFILE="$XDG_DATA_HOME/pg/pgpass"
export PGSERVICEFILE="$XDG_DATA_HOME/pg/pg_service.conf"

# pyenv
export PYENV_ROOT="$XDG_DATA_HOME/pyenv"
path_add_pre "$PYENV_ROOT/shims"

# python
# https://github.com/python/cpython/pull/13208
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonrc.py"

# qt
[ "$XDG_CURRENT_DESKTOP" = "KDE" ] || [ "$XDG_CURRENT_DESKTOP" = "GNOME" ] \
	|| export QT_QPA_PLATFORMTHEME="qt5ct"

# readline
export INPUTRC="$XDG_CONFIG_HOME/readline/inputrc"

# rm
alias rm='rm --preserve-root=all'

# rust
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
path_add_pre "$CARGO_HOME/bin"

# rvm
test -x "$XDG_DATA_HOME/rvm/scripts/rvm" \
	&& . "$XDG_DATA_HOME/rvm/scripts/rvm"
path_add_pre "$XDG_DATA_HOME/rvm/bin"
path_add_pre "$XDG_DATA_HOME/gem/bin"

# sccache
export SCCACHE_DIR="$XDG_CACHE_HOME/sccache"
export SCCACHE_CACHE_SIZE="20G"

# screen
export SCREENRC="$XDG_CONFIG_HOME/screenrc"

# sdkman
export SDKMAN_DIR="$XDG_DATA_HOME/sdkman"

# snap
#export PATH="/snap/bin:$PATH"
path_add_post "/var/lib/snapd/snap/bin"

# sonarlint
export SONARLINT_USER_HOME="$XDG_DATA_HOME/sonarlint"
mkdir -p "$SONARLINT_USER_HOME"

# stack
export STACK_ROOT="$XDG_DATA_HOME/stack"

# starship
export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"

# subversion
export SUBVERSION_HOME="$XDG_CONFIG_HOME/subversion"

# sudo (sudo alises; see `info bash -n Aliases` for details)
alias sudo='sudo '

# task
export TASKRC="$XDG_CONFIG_HOME/taskwarrior/taskrc"

# terraform
#export TF_CLI_CONFIG_FILE="$XDG_DATA_HOME/terraform/terraformrc-custom"

# texmf
export TEXMFHOME="$XDG_DATA_HOME/textmf"

# tmux
alias tmux='tmux -f "$XDG_CONFIG_HOME/tmux/tmux.conf"'
export TMUX_TMPDIR="$XDG_RUNTIME_DIR"

# vdir
alias vdir='vdir --color=auto'

# vagrant
export VAGRANT_HOME="$XDG_DATA_HOME/vagrant"
export VAGRANT_ALIAS_FILE="$VAGRANT_HOME/aliases"

# vim
export VIMINIT="source $XDG_CONFIG_HOME/vim/vimrc"

# wasmer
export WASMER_DIR="$XDG_DATA_HOME/wasmer"
# # shellcheck source=~/$XDG_DATA_HOME/wasmer/wasmer.sh
# test -x "$WASMER_DIR/wasmer.sh" && . "$WASMER_DIR/wasmer.sh"

# wasmtime
export WASMTIME_HOME="$XDG_DATA_HOME/wasmtime"
path_add_pre "$WASMTIME_HOME/bin"

# wget
#WGETRC=
alias wget='wget --config=$XDG_CONFIG_HOME/wget/wgetrc'

# wolfram mathematica
export MATHEMATICA_BASE="/usr/share/mathematica"
export MATHEMATICA_USERBASE="$XDG_DATA_HOME/mathematica"

# yarn
path_add_pre "$XDG_DATA_HOME/yarn/bin"
export YARN_CACHE_FOLDER="$XDG_CACHE_HOME/yarn"

# yay
alias yay='yay --color=auto'

# z
export _Z_DATA="$XDG_DATA_HOME/z"

# zfs
export ZFS_COLOR=

# ---------------------------------- Cleanup --------------------------------- #
unset -f path_add_pre
unset -f path_add_pre

export PATH="/home/edwin/data/cargo/bin:$PATH"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/data/rvm/bin"
