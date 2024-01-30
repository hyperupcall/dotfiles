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
curl -#fsSLo ~/.bootstrap/bootstrap.sh 'https://raw.githubusercontent.com/hyperupcall/dotfiles/trunk/os/unix/bootstrap.sh'
chmod +x ~/.bootstrap/bootstrap.sh
~/.bootstrap/bootstrap.sh
```

The `bootstrap.sh` script performs the following steps:

- Installs Homebrew on macOS
- Installs cURL, Git and Neovim
- Clones `hyperupcall/dotfiles` to `~/.dotfiles`
- Symlinks scripts to `~/scripts`
- Creates a `~/.bootstrap/bootstrap-out.sh`; sourcing it does the following:
  - Sets `NAME`, `EMAIL`, `EDITOR`, `VISUAL`
  - Appends `$HOME/.dotfiles/.data/bin` to `PATH`
  - Sources `~/.dotfiles/xdg.sh`, if it exists

Then, run the following:

```sh
. ~/.bootstrap/bootstrap-out.sh
```

Now, execute:

```sh
~/scripts/lifecycle/bootstrap.sh
source ~/.bootstrap/bootstrap-out.sh
~/scripts/lifecycle/idempotent.sh
```

## Next Steps

Some scripts should be executed. They include:

- Setup ZFS, BTRFS
  - Modify `/etc/fstab`
- Install SSH, PGP keys, and pass (pass-browserpass, and `~/.password-store`)
- Setup Albert
  - Enable plugins
- Setup pass, pass-browserpass
- Setup Firefox, Brave
  - sync
- Setup Obsidian
- Setup Maestral
- Retrieve SSH, PGP keys
- Setup default, my-tools, hub, etc.
- Install Mise
- Configure keybindings
- Test spellchecker
- Run doctor
