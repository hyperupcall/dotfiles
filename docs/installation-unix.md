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

## Bootstrap

Download and execute `bootstrap.sh` to begin the bootstrap process:

```sh
mkdir -p ~/.bootstrap
curl -#fsSLo ~/.bootstrap/bootstrap.sh 'https://raw.githubusercontent.com/hyperupcall/dotfiles/trunk/os-unix/bootstrap.sh'
chmod +x ~/.bootstrap/bootstrap.sh
~/.bootstrap/bootstrap.sh
```

The `bootstrap.sh` script performs the following steps:

- Installs Homebrew on macOS
- Installs cURL, Git and Vim
- Clones `hyperupcall/dotfiles` to `~/.dotfiles`
- Symlinks scripts to `~/scripts`
- Creates a `~/.bootstrap/bootstrap-out.sh`. Sourcing it:
  - Sets `NAME`, `EMAIL`, `EDITOR`, and `VISUAL`
  - Prepends `$HOME/.dotfiles/.data/bin` to `PATH`
  - Sources `~/.dotfiles/os-unix/data/xdg.sh`, if it exists

## Next Steps

Some scripts should be executed. They include:

- `. ~/.bootstrap/bootstrap-out.sh`
- `~/scripts/rare/transfer-secrets.sh`
  - Transfer SSH, PGP files to computer
- Setup ZFS, BTRFS
- `~/scripts/doctor.sh`
  - Write to `~/.dotfiles/.data/{profile,github_token}`
  - Check permissions for `~/.{ssh,gnupg}`
  - Setup [dev](https://github.com/fox-incubating/dev)
    - Install NodeJS v23.6.0
  - Setup [d](https://github.com/fox-incubating/d)
  - Setup mise, lefthook
    - Configure for `~/.dotfiles`
  - Setup Git (at least v2.37.0)
  - Setup Neovim (at least v0.10.0)
  - Setup pass
  - Setup Browsers (Firefox, Brave)
    - Sync data (do manually)
  - Setup Maestral
  - Setup gh, bats
- Setup Albert
  - Enable plugins
- Setup Obsidian
- Setup default, my-tools, hub, etc.
- Setup Visual Studio Code
  - Enable plugins
- Setup Thunderbird
  - Enable plugins
- Configure keybindings
- Test spellchecker
- Add favorites to file explorer and dock
- `~/scripts/idempotent.sh`
- `d deploy`
