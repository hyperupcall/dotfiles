# Getting Started

`dots-bootstrap` assumes that you are logged into a user account on an operating system. It bootstraps the dotfiles located at [hyperupcall/dots](https://github.com/hyperupcall/dots)

## Steps

### 0. Network connection

Depending on operating system, manual network configuration may be required

```sh
> /etc/systemd/network/90-main.network <<-EOF cat
	[Match]
	Name=en*

	[Network]
	Description=Main Network
	DHCP=yes
	DNS=1.1.1.1
EOF

systemctl daemon-reload
systemctl enable --now systemd-{network,resolve}d
```

### 1. `pre-bootstrap.sh`
TODO

Execute the script. It will clone this repository and tell you what to source and execute
```sh
curl -LsSo ~/.bootstrap/pre-bootstrap.sh --create-dirs https://raw.githubusercontent.com/eankeen/dotty-bootstrap/tree/master/pre-bootstrap.sh
chmod +x ~/.bootstrap/pre-bootstrap.sh
~/.bootstrap/pre-bootstrap.sh
```
