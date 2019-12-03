#!/bin/sh

if [ "$NUKE_PREEXISTING_DOTS" = "true" ]
then
    rm -f "$HOME/.bashrc"
    rm -f "$HOME/.bash_history"
fi

export HISTFILE="$XDG_DATA_HOME/bash_history"
export BASH_ENV="$CFG_DIR/bashrc"
