# List

TODO

Prerequisites
    - Network
    - dotty
    - cURL

Bootstrapped:
    - /etc/hostname
    - /etc/hosts
    - /etc/fstab
    - timedatectl
    - hwlock
    - /etc/locale.gen
    - locale-gen
    - groupadd {docker,lxd,...}
    - passwd
    - eankeen/dotty

Remember:
    - dots-bootstrap install
    - mkinitcpio
    - Initramfs / Kernel (lvm2)
    - Root Password
    - Bootloader / refind
    - Compile at /usr/share/doc/git/contrib/credential/libsecret/git-credential-libsecret
