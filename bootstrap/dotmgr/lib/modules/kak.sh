# shellcheck shell=bash

util.ensure_bin kak

git clone "https://github.com/andreyorst/plug.kak.git" "$XDG_CONFIG_HOME/kak/plugins/plug.kak"
