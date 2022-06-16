# Installation

## Prerequisites

A network connection is required. A basic network configuration for `systemd-networkd` is shown below

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

## Bootstrapping

Download and execute `stage0.sh` to begin the bootstrap process

```sh
mkdir -p ~/.bootstrap
curl -LsSo ~/.bootstrap/stage0.sh 'https://raw.githubusercontent.com/hyperupcall/dots/main/bootstrap/stage0.sh'
chmod +x ~/.bootstrap/stage0.sh
~/.bootstrap/stage0.sh
```

The `stage0.sh` script performs the following steps:

- Installs homebrew if on macOS (a required package manager)
- Ensures installation of Git and NeoVim
- Clones this repository to `~/.dots`
- Creates a `~/.bootstrap/stage0-out.sh`; sourcing it does the following
  - Sets `NAME`, `EMAIL`, `EDITOR`, `VISUAL`
  - Appends `$HOME/.dots/.usr/bin` to `PATH`
  - Sources `~/.dots/xdg.sh`

Then, run the following

```sh
. ~/.bootstrap/stage0-out.sh
dotmgr bootstrap
. ~/.bootstrap/bootstrap-out.sh

# Now, use any dotmgr subcommand
dotmgr action
```

Now, make sure this repository is properly set up

```sh
( cd ~/.dots && { ./bake init; hookah refresh; } )
sudo dotmgr
```
