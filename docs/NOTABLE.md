# Notable Things

You might find these useful

## [`createGenerated.sh`](../user/config/bash/scripts/createGenerated.sh)

Script that automatically generates bash startup scripts
for remote servers and the root user based on annotations of functions, aliases, and readline declarations
of the current dotfiles

## [`readline.sh`](../user/config/bash/modules/readline.sh)

Special bash readline bindings that includes many convenient functionality that include:

- Alt+M to bring up man page (of command/alias currently being edited)
  - very useful, as you can view a man page without having to switch readline editing buffers
- Alt+H to print help menu (of command/alias currently being edited)
  - very useful, as you can view arguments and flags quickly
- Alt+S to toggle sudo
- Alt+/ to toggle comment
- Alt+\ to toggle backslash

## [`mkt.sh`](../user/config/profile/fns/mkt.sh)

Quick command to automatically do something in a temporary space. Based on the first argument, it will

- (blank) => cd to new random directory in tempfs (`cd "$(mktemp -d)"`)
- (file/folder) => copy file/folder to new random directory in tempfs, and cd/ls to it
- (git repository) => clone (optionally sparse) repo to new random directroy in tempfs, and cd/ls to it
- (internet file) => wget file to new random directory in tempfs, and cd/ls to it

It will log temporary directories to `~/.history/mkt_history` so you can view where something is if you're worked in that
place for a prolonged period of time

## [`xdg.sh`](../user/config/profile/xdg.sh)

Contains environment variables and alises that make programs more XDG-compliant. At around ~500 lines, it will reduce the chances that files and folders such as `.go`, `.z`, `.wine`, `.rvm` will be created in your home directory. It places them in `$XDG_CONFIG_HOME`, `$XDG_DATA_HOME`, `$XDG_RUNTIME_DIR`, etc. instead. One thing to note, any parameters relating to history are set to a file in `~/.history`, rather than some place in `$XDG_DATA_HOME`.

## [fox-default](../user/config/fox-default)

A collection of aggregations of similar applications with a distinct, common, primary purpose, such as `image-viewer`. For now, you can list each aggregation and set/run an application participant of a particular aggregation with a command. The main scripts are located at https://github.com/eankeen/fox-default
