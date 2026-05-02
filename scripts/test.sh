#!/usr/bin/env bash
docker run -it \
	-v ~/.dotfiles:/home/username/.dotfiles \
	-v /mnt2:/mnt2 \
	fedora:latest \
	/bin/bash < <(
		cat <<"EOF"
if command -v apt-get &>/dev/null; then
	apt-get install -y minimize
		unminimize
	fi
	username=username
	useradd -m -s /bin/bash "$username"
	# TMP> add to .d
	echo "$username ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
	chown -R "$username:$username" "/home/$username/.dotfiles
	if ! command -v su &>/dev/null; then
	   if command -v dnf &>/dev/null; then
	  	dnf install -y su
	   fi
	fi
	su - "$username"
EOF
	)
