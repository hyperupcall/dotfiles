# Installation

## Prerequisites

A network connection is required. A basic network configuration for systemd example is shown below

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

## With bootstrap

To begin the bootstrap process, the `stage-0.sh` script must be downloaded and executed

```sh
mkdir -p ~/.bootstrap
curl -LsSo ~/.bootstrap/stage-0.sh https://raw.githubusercontent.com/hyperupcall/dots/main/bootstrap/stage-0.sh
chmod +x ~/.bootstrap/stage-0.sh
~/.bootstrap/stage-0.sh
```

The `stage-0.sh` script clones this repository, and creates a `stage-1.sh` file, among other things

```sh
. ~/.bootstrap/stage1.sh
dotmgr bootstrap-stage1
```

Running `dotmgr bootstrap` installs [dotfox](https://github.com/hyperupcall/dotfox), [Basalt](https://github.com/hyperupcall/basalt), and creates a `stage-2.sh` file, among other things

```sh
. ~/.bootstrap/stage2.sh
dotfox --config-dir="$HOME/.dots/user/.config/dotfox" --deployment=all.sh deploy
. ~/.bashrc
dotmgr bootstrap-stage2
```
