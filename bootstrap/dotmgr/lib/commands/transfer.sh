# shellcheck shell=bash

subcmd() {
	sudo -v

	local usb_partition_uuid='5886-60A0'

	local blockDev="/dev/disk/by-uuid/$usb_partition_uuid"
	if [ ! -e "$blockDev" ]; then
		util.die "USB Not plugged in"
	fi

	local blockDevTarget=
	if ! blockDevTarget="$(findmnt -no TARGET "$blockDev")"; then
		# 'findmnt' exits failure if cannot find block device. We account
		# for that case with '[ -z "$blockDevTarget" ]' below
		:
	fi

	# If the USB is not already mounted
	if [ -z "$blockDevTarget" ]; then
		if mountpoint -q /mnt; then
			util.die "Directory '/mnt' must not already be a mountpoint"
		fi

		util.run sudo mount "$blockDev" /mnt

		if ! blockDevTarget="$(findmnt -no TARGET "$blockDev")"; then
			util.die "Automount failed"
		fi
	fi

	# Now, file system is mounted at "$blockDevTarget"

	# Copy (encrypted) password-store
	util.log_info "Copying password-store"
	cp -Lr "${PASSWORD_STORE_DIR:-$HOME/.password-store}" "$blockDevTarget"

	util.ensure_bin expect
	util.ensure_bin age
	util.ensure_bin age-keygen

	local password=
	password="$(LC_ALL=C tr -dc 'a-km-zA-KM-Z1-9!@#%^&*~`_+' </dev/urandom | head -c 12; printf '\n')"
	util.log_info "Password: $password"

	# Copy over ssh keys
	local -r sshDir="$HOME/.ssh"
	local -a sshKeys=(github github.pub gitlab gitlab.pub)
	if [ -d "$sshDir" ]; then
		exec 4> >(sudo tee "$blockDevTarget/ssh-keys.tar.age" >/dev/null)
		if expect -f <(cat <<-EOF
			set bashFd [lindex \$argv 0]
			spawn bash \$bashFd

			expect -- "Enter passphrase*"
			send -- "$password\n"
			expect -- "Confirm passphrase*"
			send -- "$password\n"
			expect eof

			set result [wait]
			if {[lindex \$result 2] == 0} {
				exit [lindex \$result 3]
			} else {
				error "An operating system error occurred, errno=[lindex \$result 3]"
			}
		EOF
		) <(cat <<-EOF
			set -eo pipefail

			cd "$sshDir"
			tar -c ${sshKeys[*]} | age --encrypt --passphrase --armor >&4
		EOF
		); then :; else
			util.die "Command 'expect' failed (code $?)"
		fi
		exec 4<&-
	else
		util.log_warn "Skipping copying ssh keys"
	fi

	# Copy over gpg keys
	local -r fingerprints=('6EF89C3EB889D61708E5243DDA8EF6F306AD2CBA' '4C452EC68725DAFD09EC57BAB2D007E5878C6803')
	local gpgDir="$HOME/.gnupg"
	if [ -d "$gpgDir" ]; then
		exec 4> >(sudo tee "$blockDevTarget/gpg-keys.tar.age" >/dev/null)
		if expect -f <(cat <<-EOF
			set bashFd [lindex \$argv 0]
			spawn bash \$bashFd

			expect -- "Enter passphrase*"
			send -- "$password\n"
			expect -- "Confirm passphrase*"
			send -- "$password\n"
			expect eof

			set result [wait]
			if {[lindex \$result 2] == 0} {
				exit [lindex \$result 3]
			} else {
				error "An operating system error occurred, errno=[lindex \$result 3]"
			}
		EOF
		) <(cat <<-EOF
			set -eo pipefail

			gpg --export-secret-keys --armor ${fingerprints[*]} | age --encrypt --passphrase --armor >&4
		EOF
		); then :; else
			util.die "Command 'expect' failed (code $?)"
		fi
		exec 4<&-
	else
		util.log_warn "Skipping copying gpg keys"
	fi

	printf '%s\n' "Done."
}
