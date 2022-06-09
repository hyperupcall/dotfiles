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

To begin the bootstrap process, the `stage0.sh` script must be downloaded and executed

```sh
mkdir -p ~/.bootstrap
curl -LsSo ~/.bootstrap/stage0.sh 'https://raw.githubusercontent.com/hyperupcall/dots/main/bootstrap/stage0.sh'
chmod +x ~/.bootstrap/stage0.sh
~/.bootstrap/stage0.sh
```

The `stage0.sh` script performs the following steps

- Installs homebrew if on macOS (a required package manager)
- Ensures installation of Git and NeoVim
- Clones this repository to ~/.dots
- Creates a `stage0-out.sh`

Sourcing the `stage0-out.sh` performs the following steps

- Sets `NAME`, `EMAIL`, `EDITOR`, `VISUAL`
- Appends `$HOME/.dots/.usr/bin` to `PATH`
- Sources `~/.dots/xdg.sh`

```sh
. ~/.bootstrap/stage0-out.sh
dotmgr bootstrap
```

Running `dotmgr bootstrap` installs [dotfox](https://github.com/hyperupcall/dotfox), [Basalt](https://github.com/hyperupcall/basalt), [Nim](https://nim-lang.org), and creates a `stage2.sh` file, among other things in `~/.bootstrap`. Sourcing `stage2.sh` adds the directories containing these programs to the PATH

```sh
. ~/.bootstrap/stage2.sh
dotmgr action # Choose 'Idempotent Setup'
dotmgr action # Choose 'Import Secrets'
```

```sh
( cd ~/.dots && { ./bake init; hookah refresh; } )
sudo dotmgr
```
