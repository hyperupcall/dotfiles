#!/bin/sh

# sherlock
## bash
poetry completions bash > /etc/bash_completion.d/poetry.bash-completion

## fish
poetry completions fish > ~/.config/fish/completions/poetry.fish

## zsh
poetry completions zsh > ~/.zfunc/_poetry

## oh-my-zsh
mkdir $ZSH/plugins/poetry
poetry completions zsh > $ZSH/plugins/poetry/_poetry
