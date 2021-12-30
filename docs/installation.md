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

To begin the bootstrap process, the `stage0.sh` script must be downloaded and executed

```sh
mkdir -p ~/.bootstrap
curl -LsSo ~/.bootstrap/stage0.sh https://raw.githubusercontent.com/hyperupcall/dots/main/bootstrap/stage0.sh
chmod +x ~/.bootstrap/stage0.sh
~/.bootstrap/stage0.sh
```

The `stage0.sh` script clones this repository, and creates a `stage1.sh` file, among other things. Sourcing the `stage1.sh` adds the directory containing `dotmgr` to the PATH, and set basic environment variables like `NAME`, `EDITOR`, and XDG Base Directory Environment Variables

```sh
. ~/.bootstrap/stage1.sh
dotmgr bootstrap-stage1
```

Running `dotmgr bootstrap` installs [dotfox](https://github.com/hyperupcall/dotfox), [Basalt](https://github.com/hyperupcall/basalt), [Nim](https://nim-lang.org), and creates a `stage2.sh` file, among other things. Sourcing `stage2.sh` adds the directories containing these programs to the PATH

```sh
. ~/.bootstrap/stage2.sh
dotmgr bootstrap-stage2

. ~/.bashrc
dotmgr maintain
```
