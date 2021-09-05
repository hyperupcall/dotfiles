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

To begin the bootstrap process, the `pre-bootstrap.sh` script must be downloaded and executed

```sh
mkdir -p ~/.bootstrap
curl -LsSo ~/.bootstrap/pre-bootstrap.sh https://raw.githubusercontent.com/hyperupcall/dots/main/bootstrap/pre-bootstrap.sh
chmod +x ~/.bootstrap/pre-bootstrap.sh
~/.bootstrap/pre-bootstrap.sh
```

Once you do this, then execute the real `dots-bootstrap` script

```sh
. ~/.bootstrap/profile-pre-bootstrap.sh
dots-bootstrap bootstrap
```

## Without bootstrap

Use the following commands if you wish to clone the dotfiles without executing any bootstrap instructions

```sh
git clone https://github.com/hyperupcall/dots
cd dots
git config --local filter.npmrc-clean.clean "$(pwd)/user/config/npm/npmrc-clean.sh"
git config --local filter.slack-term-config-clean.clean "$(pwd)/user/config/slack-term/slack-term-config-clean.sh"
git config --local filter.oscrc-clean.clean "$(pwd)/user/config/osc/oscrc-clean.sh"
```
