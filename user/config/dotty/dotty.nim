#!/usr/bin/env -S nim --hints:off r dotty
import os

proc xdgCfg: string =
  if getEnv("XDG_CONFIG_HOME") != "":
    return getEnv("XDG_CONFIG_HOME")
  else:
    return joinPath(getEnv("HOME"), ".config")

proc xdgData: string =
  if getEnv("XDG_DATA_HOME") != "":
    return getEnv("XDG_DATA_HOME")
  else:
    return joinPath(getEnv("HOME"), ".local/share")

let home = getHomeDir()
let cfg = xdgCfg() & "/"
let data = xdgData() & "/"

let dotConfigFiles = [
  home & ".alsoftrc",
  home & ".bash_logout",
  home & ".bash_profile",
  home & ".bashrc",
  home & ".pam_environment",
  home & ".profile",
  home & ".yarnrc",
  home & ".config/conky",
  cfg & "alacritty",
  cfg & "albert/albert.conf",
  cfg & "albert-sticker-searcher",
  cfg & "appimagelauncher.cfg",
  cfg & "awesome",
  cfg & "bash",
  cfg & "bash_completion",
  cfg & "bat",
  cfg & "broot",
  cfg & "cabal/config",
  cfg & "calcurse",
  cfg & "cava",
  cfg & "chezmoi",
  cfg & "cliflix",
  cfg & "conky",
  cfg & "cookiecutter",
  cfg & "cmus/rc",
  cfg & "Code/User/keybindings.json",
  cfg & "Code/User/settings.json",
  cfg & "curl",
  cfg & "dircolors",
  cfg & "dotty",
  cfg & "dunst",
  cfg & "environment.d",
  cfg & "fish",
  cfg & "fontconfig",
  cfg & "fox-default",
  cfg & "gh",
  cfg & "git",
  cfg & "hg",
  cfg & "htop",
  cfg & "i3",
  cfg & "i3status",
  cfg & "info",
  cfg & "ion",
  cfg & "irssi",
  cfg & "kitty",
  cfg & "lazydocker",
  cfg & "liquidpromptrc",
  cfg & "maven",
  cfg & "micro",
  cfg & "mnemosyne/config.py",
  cfg & "nano",
  cfg & "neofetch",
  cfg & "nimble",
  cfg & "nitrogen",
  cfg & "npm",
  cfg & "nu",
  cfg & "nvim",
  cfg & "pamix.conf",
  cfg & "picom",
  cfg & "pijul",
  cfg & "polybar",
  cfg & "profile",
  cfg & "pulse/client.conf",
  cfg & "pulsemixer.cfg",
  cfg & "python",
  cfg & "ranger",
  cfg & "readline",
  cfg & "redshift",
  cfg & "ripgrep",
  cfg & "rofi",
  cfg & "rtorrent",
  cfg & "salamis",
  cfg & "starship",
  cfg & "sxhkd",
  cfg & "systemd",
  cfg & "terminator",
  cfg & "termite",
  cfg & "tilda",
  cfg & "tmux",
  cfg & "todotxt",
  cfg & "urxvt",
  cfg & "user-dirs.dirs",
  cfg & "viewnior",
  cfg & "vim",
  cfg & "wget",
  cfg & "X11",
  cfg & "xob",
  cfg & "yay",
  cfg & "zsh",
  data & "gnupg/gpg.conf",
  data & "gnupg/dirmngr.conf",
  data & "applications/Calcurse.desktop",
  data & "applications/Nemo.desktop",
  data & "applications/Obsidian.desktop",
  data & "applications/Zettlr.desktop",
  data & "sdkman/etc/config"
]

for i, str in dotConfigFiles:
  echo str
