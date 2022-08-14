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

Download and execute `bootstrap.sh` to begin the bootstrap process

```sh
mkdir -p ~/.bootstrap
curl -fLsSo ~/.bootstrap/bootstrap.sh 'https://raw.githubusercontent.com/hyperupcall/dots/trunk/dotmgr/bootstrap.sh'
chmod +x ~/.bootstrap/bootstrap.sh
~/.bootstrap/bootstrap.sh
```

The `bootstrap.sh` script performs the following steps:

- Installs Homebrew, on macOS
- Installs Git and NeoVim
- Clones `hyperupcall/dots` to `~/.dots`
- Clones `hyperupcall/dotmgr` to `~/.dots/.dotmgr`
- Creates a `~/.bootstrap/bootstrap-out.sh`; sourcing it does the following
  - Sets `NAME`, `EMAIL`, `EDITOR`, `VISUAL`
  - Appends `$HOME/.dots/.usr/bin` to `PATH`
  - Sources `~/.dots/xdg.sh`

Then, run the following

```sh
. ~/.bootstrap/bootstrap-out.sh
dotmgr bootstrap

# Now, use any dotmgr subcommand
dotmgr action bootstrap
```

Now, make sure this repository is properly set up

```sh
( cd ~/.dots && { ./bake init; hookah refresh; } )
sudo dotmgr
```

## Troubleshooting

1. dotmgr not found

```txt
dotmgr: command not found
```

Solution is to execute it manually like so:

```sh
~/.dots/.dotmgr/src/ibn
```

If that file does not exist, you must re-bootstrap everything
