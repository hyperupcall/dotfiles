---
layout: page
title: Installation (Unix)
---

# Installation

## Prerequisites

A network connection is required. A basic network configuration for `systemd-networkd` is shown below:

```sh
>/etc/systemd/network/90-wired.network <<-EOF cat
	[Match]
	Name=en*

	[Network]
	Description=Wired Connection
	DHCP=yes
	DNS=1.1.1.1
EOF

systemctl daemon-reload
systemctl enable --now systemd-{network,resolve}d
```

**Remember to copy important data from your old computer!** See your _Setting up Linux_ note.

## Bootstrap

Download and execute `bootstrap-linux.sh` to begin the bootstrap process:

```sh
mkdir -p ~/.bootstrap
curl -#fsSLo ~/.bootstrap/bootstrap.sh 'https://raw.githubusercontent.com/hyperupcall/dotfiles/trunk/bootstrap-linux.sh'
chmod +x ~/.bootstrap/bootstrap.sh
~/.bootstrap/bootstrap.sh
```

The bootstrap script performs the following steps:

- Installs Homebrew on macOS
- Installs cURL, Git and Vim
- Clones `hyperupcall/dotfiles` to `~/.dotfiles`
- Symlinks `~/scripts` to `~/.dotfiles/scripts`
- Creates `~/.bootstrap/bootstrap-out.sh`. Sourcing it:
  - Sets `NAME`, `EMAIL`, `EDITOR`, and `VISUAL`
  - Prepends `$HOME/.dotfiles/.data/bin` to `PATH`
  - Sources `~/.dotfiles/data/xdg.sh`, if it exists

## Next Steps

Additional scripts should be executed. They include:

- `. ~/.bootstrap/bootstrap-out.sh`
- `~/scripts/rare/transfer-secrets.sh`
  - Transfer SSH, PGP files to computer
- Setup ZFS, BTRFS
- `~/scripts/doctor.sh`
  - Install required dependencies
  - Fix files in home directory
    - Remove broken home directory symlinks
    - Remove autoappended lines in shell startup files
    - Create necessary symlinks
    - Set XDG user directories
    - Symlink XDG base and user directories
    - Add and remove necessary directories, files, and groups
  - Write to `~/.dotfiles/.data/{profile,github_token}`
  - Check permissions for `~/.{ssh,gnupg}`
  - Setup [dev](https://github.com/fox-incubating/dev)
    - Install NodeJS v23.6.0
  - Setup [d](https://github.com/fox-incubating/d)
  - Setup mise and lefthook
    - Configure for `~/.dotfiles`
  - Setup Git (at least v2.37.0)
  - Setup Neovim (at least v0.10.0)
  - Setup pass
  - Setup Browsers (Firefox, Brave)
    - Backup and restore settings (_do manually_):
      - uBlacklist
      - uBlock Origin
      - SponsorBlock
      - ViolentMonkey
    - Sync data (_do manually_)
  - Setup Maestral
  - Setup Visual Studio Code
    - Install extensions (_do manually_)
  - Setup Thunderbird
    - Install extensions (_do manually_)
  - Setup Bats, `gh`
- Configure AppImageLauncher
  - Set destination directory
- Setup Albert
  - Enable plugins
- Setup Obsidian
- Setup LibreOffice
  - Backup and restore (_do manually_)
    - SpellCheck dictionary
    - Document templates
- Configure keybindings
- Test spellchecker
- Add favorites to file explorer and dock
