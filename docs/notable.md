# Notables

The following scripts are notable and may be helpful to others:

## [`readline.sh`](/os-unix/config-shell/.config/bash/modules)

Special Bash readline bindings that includes many convenient functionality that include:

- <kbd>Alt+M</kbd> to bring up man page (of command/alias currently being edited)s
  - extremely useful, as you can view a man page without having to switch readline editing buffers
- <kbd>Alt+H</kbd> to print help menu (of command/alias currently being edited)
  - extremely useful, as you can view arguments and flags quickly
- <kbd>Alt+S</kbd> to toggle sudo
- <kbd>Alt+/</kbd> to toggle comment
- <kbd>Alt+\</kbd> to toggle backslash

It calls more general functions that can be found at [`line-editing.sh`](/os-unix/config-shell/.config/sh/modules/line-editing.sh).

## [`mkt.sh`](/os-unix/config-shell/.config/sh/modules/func-mkt.sh)

Quick command to automatically do something in a temporary space. Based on the first argument, it will:

- (blank) => cd to new random directory in tempfs (`cd "$(mktemp -d)"`)
- (file/folder) => copy file/folder to new random directory in tempfs, and cd/ls to it
- (git repository) => clone (optionally sparse) repo to new random directroy in tempfs, and cd/ls to it
- (internet file) => curl file to new random directory in tempfs, and cd/ls to it

It will create a history of invocations at `$XDG_STATE_HOME/history/mkt_history`.

## [`xdg.sh`](/os-unix/config-shell/.config/sh/modules/env-xdg.sh)

Sets environment variables and alises that make programs more compliant with the XDG Base Directory specification. It will reduce the creation of folders in the home directory like `~/.go`, `~/.z`, and so on.
