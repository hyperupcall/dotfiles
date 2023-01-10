#!/usr/bin/env bash

p() {
	printf "%s\n" "$@"
}

# p "/efi/EFI/refind/refind-theme-regular"
# p "/efi/EFI/refind/boot-list.conf"
# p "/efi/EFI/refind.conf"
p '/etc/binfmt.d/10-go.conf'
p '/etc/binfmt.d/10-nim.conf'
p '/etc/udev/rules.d/51-gc-adapter.rules'
p '/etc/modprobe.d/90-nvidia-i2c.conf'
p '/etc/X11/xorg.conf.d/90-nvidia-i2c.conf'

[ "$(lsb_release -i | awk '{ print $NF }')" = "Arch" ] && {
	p '/etc/pacman.d/hooks/audit.hook'
	p '/etc/pacman.d/hooks/dash-as-sh.hook'
	p '/etc/pacman.d/hooks/tweak-path.hook'
#	p /etc/pacman.d/hooks/pyenv-switch-{restore,system}.hook
}

p /root/.bashrc{,-generated-aliases,-generated-functions}
p '/root/.nanorc'
p '/root/.config/dotty'
p '/root/.dir_colors'
