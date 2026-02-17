# shellcheck shell=sh

export_xdg_vars() {
	# Android
	export ANDROID_HOME="$XDG_STATE_HOME/Android/Sdk"
	# _util_path_prepend "$ANDROID_HOME/emulator"
	_util_path_prepend "$ANDROID_HOME/tools"
	_util_path_prepend "$ANDROID_HOME/tools/bin"
	_util_path_prepend "$ANDROID_HOME/platform-tools"
	export ANDROID_USER_HOME="$XDG_STATE_HOME/Android/User"

	# AWS
	export AWS_SHARED_CREDENTIALS_FILE="$XDG_STATE_HOME/aws/credentials"
	export AWS_CONFIG_FILE="$XDG_STATE_HOME/aws/config"

	# Azure
	export AZURE_CONFIG_DIR="$XDG_STATE_HOME/azure"

	# Babel
	export BABEL_CACHE_PATH="$XDG_CACHE_HOME/babel.json"

	# bash-completion
	export BASH_COMPLETION_USER_DIR="$XDG_CONFIG_HOME/bash"
	export BASH_COMPLETION_USER_FILE="$XDG_CONFIG_HOME/bash/bash_completion.sh"

	# Boto
	export BOTO_CONFIG="$XDG_DATA_HOME/boto"

	# Bundler
	export BUNDLE_USER_CONFIG="$XDG_CONFIG_HOME/bundle"
	export BUNDLE_USER_CACHE="$XDG_CACHE_HOME/bundle"
	export BUNDLE_USER_PLUGIN="$XDG_DATA_HOME/bundle"

	# Cinelerra
	export CIN_CONFIG="$XDG_CONFIG_HOME/bcast5"

	# Conan
	export CONAN_HOME="$XDG_STATE_HOME/conan2"

	# cpanm
	export PERL_CPANM_HOME="$XDG_DATA_HOME/cpanm"

	# crawl
	export CRAWL_DIR="$XDG_DATA_HOME/crawl/" # Trailing slash required.

	# curl
	export CURL_HOME="$XDG_CONFIG_HOME/curl"

	# Dart
	export PUB_CACHE="$XDG_CACHE_HOME/pub-cache"

	# Docker
	export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"

	# docker-machine
	export MACHINE_STORAGE_PATH="$XDG_DATA_HOME/docker-machine"

	# DUC
	export DUC_DATABASE="$XDG_DATA_HOME/duc.db"

	# libdvdcss
	export DVDCSS_CACHE="$XDG_CACHE_HOME/dvdcss"

	# Electrum
	export ELECTRUMDIR="$XDG_DATA_HOME/electrum"

	# elinks
	export ELINKS_CONFDIR="$XDG_CONFIG_HOME/elinks"

	# Emscripten
	# export EM_CONFIG="$XDG_CONFIG_HOME/emscripten/config"
	export EM_CACHE="$XDG_CACHE_HOME/emscripten"
	# export EM_PORTS="$XDG_DATA_HOME/emscripten/cache"

	# RubyGems
	export GEM_HOME="$XDG_DATA_HOME/gem" # conflicts with rvm
	export GEM_SPEC_CACHE="$XDG_CACHE_HOME/gem"
	_util_path_prepend "$GEM_HOME/bin"

	# get_iplayer
	export GETIPLAYERUSERPREFS="$XDG_DATA_HOME/get_iplayer"

	# GHCup (Haskell)
	export GHCUP_INSTALL_BASE_PREFIX="$XDG_DATA_HOME/ghcup"
	_util_path_prepend "$GHCUP_INSTALL_BASE_PREFIX/bin" # requires symlink

	# gitlib
	export GITLIBS="$XDG_DATA_HOME/gitlibs"

	# GNUstep
	export GNUSTEP_USER_ROOT="$XDG_DATA_HOME/GNUstep"

	# gPodder
	export GPODDER_HOME="$XDG_DATA_HOME/gPodder"

	# Gradle
	export GRADLE_USER_HOME="$XDG_DATA_HOME/gradle"

	# Grip
	export GRIPHOME="$XDG_CONFIG_HOME/grip"

	# GTK
	export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"

	# hledger
	export LEDGER_FILE="$XDG_STATE_HOME/hledger/hledger.journal"

	# IDA
	export IDAUSR="$XDG_STATE_HOME/idapro"

	# imapfilter
	export IMAPFILTER_HOME="$XDG_CONFIG_HOME/imapfilter"

	# info
	alias info='info --init-file $XDG_CONFIG_HOME/info/infokey'

	# IPFS
	export IPFS_PATH="$XDG_DATA_HOME/ipfs"

	# IPython
	export IPYTHONDIR="$XDG_CONFIG_HOME/jupyter"

	# IRB
	export IRBRC="$XDG_CONFIG_HOME/irb/irbrc"

	# Java
	# export _JAVA_OPTIONS="-Djava.util.prefs.userRoot=$XDG_STATE_HOME/java"
	# export JAVA_TOOL_OPTIONS="$_JAVA_OPTIONS"

	# Julia
	export JULIA_DEPOT_PATH="$XDG_DATA_HOME/julia:$JULIA_DEPOT_PATH"

	# JuNest
	export JUNEST_HOME="$XDG_DATA_HOME/junest"

	# Jupyter
	export JUPYTER_CONFIG_DIR="$XDG_CONFIG_HOME/jupyter"

	# LDAP
	# export LDAPRC="$XDG_CONFIG_HOME/ldap.conf"

	# Leiningen
	export LEIN_HOME="$XDG_STATE_HOME/lein"

	# ltrace
	alias ltrace='ltrace -F "$XDG_CONFIG_HOME/ltrace/ltrace.conf"'

	# Maven
	alias mvn='mvn -gs "$XDG_CONFIG_HOME/maven/settings.xml"'

	# Maxima
	export MAXIMA_USERDIR="$XDG_CONFIG_HOME/maxima"

	# mbsync
	export MBSYNC_CONFIG="$XDG_CONFIG_HOME/mbsync/config"

	# Mednafen
	export MEDNAFEN_HOME="$XDG_CONFIG_HOME/mednafen"

	# most
	export MOST_INITFILE="$XDG_CONFIG_HOME/most/mostrc"

	# MPlayer
	export MPLAYER_HOME="$XDG_STATE_HOME/mplayer"

	# Node.js

	# notmuch
	export NOTMUCH_CONFIG="$XDG_CONFIG_HOME/notmuch/notmuchrc"
	export NMBGIT="$XDG_DATA_HOME/notmuch/nmbug"

	# npm
	export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"

	# NuGet
	export NUGET_PACKAGES="$XDG_DATA_HOME/nuget/packages"

	# GNU Octave

	# pass
	export PASSWORD_STORE_DIR="$XDG_DATA_HOME/password-store"

	# Perl
	export PERL_LOCAL_LIB_ROOT="$XDG_DATA_HOME/perl5"
	export PERL_MB_OPT="--install_base \"$PERL_LOCAL_LIB_ROOT\""
	export PERL_MM_OPT="INSTALL_BASE=\"$PERL_LOCAL_LIB_ROOT\""
	_util_path_prepend "$PERL_LOCAL_LIB_ROOT/bin"
	_util_path_prepend PERL5LIB "$PERL_LOCAL_LIB_ROOT/lib/perl5"

	# pipx
	export PIPX_BIN_DIR="$XDG_STATE_HOME/pipx/bin"

	# PlatformIO
	# export PLATFORMIO_CORE_DIR="$XDG_STATE_HOME/platformio"
	# _util_path_prepend "$PLATFORMIO_CORE_DIR/penv/bin"

	# Poetry
	_util_path_prepend "$XDG_DATA_HOME/pypoetry/bin"

	# PostgreSQL
	export PSQLRC="$XDG_DATA_HOME/pg/psqlrc"
	export PGPASSFILE="$XDG_DATA_HOME/pg/pgpass"
	export PGSERVICEFILE="$XDG_DATA_HOME/pg/pg_service.conf"

	# Python
	export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonrc.py" # https://github.com/python/cpython/pull/13208
	export PYTHON_EGG_CACHE="$XDG_CACHE_HOME/python-eggs"

	# Readline
	export INPUTRC="$XDG_CONFIG_HOME/readline/inputrc"

	# Redis
	export REDISCLI_RCFILE="$XDG_CONFIG_HOME/redis/redisclirc"

	# ripgrep
	export RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME/ripgrep/config"

	# Rust
	export CARGO_HOME="$XDG_DATA_HOME/cargo"
	export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
	_util_path_prepend "$CARGO_HOME/bin"

	# ruby-build
	export RUBY_BUILD_CACHE_PATH="$XDG_CACHE_HOME/ruby-build"

	# Sage
	export DOT_SAGE="$XDG_CONFIG_HOME/sage" # Requires directory to be created.

	# SDKMAN!
	export SDKMAN_DIR="$XDG_STATE_HOME/sdkman"

	# GNU Screen
	export SCREENRC="$XDG_CONFIG_HOME/screenrc"

	# Spacemacs
	export SPACEMACSDIR="$XDG_CONFIG_HOME/spacemacs"

	# SonarLint
	export SONARLINT_USER_HOME="$XDG_DATA_HOME/sonarlint" # Requires directory to be created.

	# SQLite

	# stack
	export STACK_ROOT="$XDG_DATA_HOME/stack"

	# Starship
	export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"

	# Taskwarrior
	export TASKRC="$XDG_CONFIG_HOME/taskwarrior/taskrc"
	export TASKDATA="$XDG_DATA_HOME/taskwarrior"

	# terminfo
	# export TERMINFO="$XDG_DATA_HOME"/terminfo
	# export TERMINFO_DIRS="$XDG_DATA_HOME"/terminfo:/usr/share/terminfo

	# TeX Live (TEXMF)
	export TEXMFHOME="$XDG_DATA_HOME/textmf"
	export TEXMFVAR="$XDG_CACHE_HOME/texlive/texmf-var"
	export TEXMFCONFIG="$XDG_CONFIG_HOME/texlive/texmf-config"

	# GNU TeXmacs
	export TEXMACS_HOME_PATH="$XDG_STATE_HOME/texmacs"

	# tree-sitter
	export TREE_SITTER_DIR="$XDG_CONFIG_HOME/tree-sitter"

	# TeamSpeak 3
	export TS3_CONFIG_DIR="$XDG_CONFIG_HOME/ts3client"

	# Uncrustify
	export UNCRUSTIFY_CONFIG="$XDG_CONFIG_HOME/uncrustify/uncrustify.cfg"

	# Unison
	export UNISON="$XDG_DATA_HOME/unison"

	# Vagrant
	export VAGRANT_HOME="$XDG_DATA_HOME/vagrant"
	export VAGRANT_ALIAS_FILE="$VAGRANT_HOME/aliases"

	# vpython (Chromium)
	export VPYTHON_VIRTUALENV_ROOT="$XDG_STATE_HOME/vpython"

	# rxvt-unicode (urxvt)
	export URXVT_PERL_LIB="$XDG_CONFIG_HOME/urxvt/ext"
	export RXVT_SOCKET="$XDG_RUNTIME_DIR"/urxvtd

	# Wasmer
	export WASMER_DIR="$XDG_DATA_HOME/wasmer"
	# [ -f "$WASMER_DIR/wasmer.sh" ] && source "$WASMER_DIR/wasmer.sh"

	# Wasmtime
	export WASMTIME_HOME="$XDG_DATA_HOME/wasmtime"
	_util_path_prepend "$WASMTIME_HOME/bin"

	# Wget
	export WGETRC="$XDG_CONFIG_HOME/wget/wgetrc"

	# wine
	export WINEPREFIX="$XDG_DATA_HOME/wine"

	# Wolfram Mathematica
	export MATHEMATICA_BASE="/usr/share/mathematica"
	export MATHEMATICA_USERBASE="$XDG_DATA_HOME/mathematica"

	# Yarn
	export YARN_CACHE_FOLDER="$XDG_CACHE_HOME/yarn"
	_util_path_prepend "$HOME/.yarn/bin"
	# _util_path_prepend "$XDG_DATA_HOME/yarn/bin"
	# alias yarn='yarn --use-yarnrc "$XDG_CONFIG_HOME/yarn/config"'

	# z (autojump)
	export _Z_DATA="$XDG_DATA_HOME/z"
}

export_telemetry_vars() {
	# Angular CLI
	export NG_CLI_ANALYTICS=false

	# Arduino CLI
	export ARDUINO_METRICS_ENABLED=false

	# Azure CLI
	export AZURE_CORE_COLLECT_TELEMETRY=0

	# Google Cloud SDK
	export CLOUDSDK_CORE_DISABLE_USAGE_REPORTING=true

	# Console Do Not Track (DNT)
	export DO_NOT_TRACK=1

	# Dagster
	export DAGSTER_DISABLE_TELEMETRY=1

	# .NET Interactive
	export DOTNET_INTERACTIVE_CLI_TELEMETRY_OPTOUT=1

	# Earthly
	export EARTHLY_DISABLE_ANALYTICS=1

	# F5
	export F5_ALLOW_TELEMETRY=false

	# Go
	export GOTELEMETRY=off

	# webhint
	export HINT_TELEMETRY=off

	# InfluxDB
	export INFLUXD_REPORTING_DISABLED=true

	# Flutter
	export FLUTTER_SUPPRESS_ANALYTICS=true

	# Gatsby
	export GATSBY_TELEMETRY_DISABLED=1

	# Homebrew
	export HOMEBREW_NO_ANALYTICS=1

	# Nim (choosenim)
	export CHOOSENIM_NO_ANALYTICS=1

	# Next.js
	export NEXT_TELEMETRY_DISABLED=1

	# Nuxt
	export NUXT_TELEMETRY_DISABLED=1

	# Pants
	export PANTS_ANONYMOUS_TELEMETRY_ENABLED=false

	# PowerShell (Core)
	export POWERSHELL_TELEMETRY_OPTOUT=1

	# Stripe CLI
	export STRIPE_CLI_TELEMETRY_OPTOUT=1

	# vcpkg
	export VCPKG_DISABLE_METRICS=true
}
