# shellcheck shell=bash

# Name:
# Install Others
#
# Description:
# Installs miscellaneous packages. This includes:
# - Dropbox
# - Browserpass Brave Client
#
# The ZFS is commented out because it is not disto-agnostic (and it is hacky)

action() {
	# ZFS
	# {
	# 	source /etc/os-release # FIXME messy
	# 	if [ "$ID" = 'fedora' ]; then
	# 		printf '%s\n' "About to sudo 4 times" # FIXME
	# 		sudo dnf install -y "https://zfsonlinux.org/fedora/zfs-release$(rpm -E %dist).noarch.rpm"
	# 		sudo dnf install -y kernel-devel
	# 		sudo dnf install -y zfs
	# 		sudo modprobe zfs
	# 	fi
	# }

	# Dropbox
	{
		cd ~/.dots/.home/Downloads
		wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
		ln -sf ~/.dots/.home/Downloads/.dropbox-dist/dropboxd ~/.local/bin/dropboxd
	}

	# Browserpass
	{
		local version='3.0.9'
		print.info "Installing version '$version'"

		local url="https://github.com/browserpass/browserpass-native/releases/download/$version/browserpass-linux64-$version.tar.gz"
		cd "$(mktemp -d)"


		curl -sSLo browserpass.tar.gz "$url"
		tar xf 'browserpass.tar.gz'
		cd "./browserpass-linux64-$version/"

		local system='linux64'
		make BIN="browserpass-$system" PREFIX=/usr/local configure
		sudo make BIN="browserpass-$system" PREFIX=/usr/local install
		make BIN="browserpass-$system" PREFIX=/usr/local hosts-brave-user # '-user' works more frequently
		# sudo make BIN="browserpass-$system" PREFIX=/usr/local policies-brave
	}
}
