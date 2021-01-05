#!/bin/sh -eu
# obsolete due to /etc/binfmt.d/

checkFile() {
	[ -e "$1" ] && {
		echo "You already have an 'interpreter' associated with golang. Do 'echo -1 | sudo tee $1' to remove it before running this script."
		cat "$1"
		exit
	}
}

mount | grep -q binfmt_misc || {
	# see https://www.kernel.org/doc/html/v4.14/admin-guide/binfmt-misc.html
	echo "You don't have binfmt_misc mounted. This configuration is unsupported"
	exit 1
}

file1="/proc/sys/fs/binfmt_misc/golang"
checkFile "$file1"

file2="/proc/sys/fs/binfmt_misc/nimtcc"
checkFile "$file2"

# install gorun
go get github.com/erning/gorun

# add kernel support for executing go files with the gorun, nim 'interpreter'
echo ':golang:E::go::/usr/bin/gorun:OC' | sudo tee /proc/sys/fs/binfmt_misc/register >/dev/null
echo ':nimtcc:E::nim::/usr/local/bin/nimtcc:' | sudo tee -a /proc/sys/fs/binfmt_misc/register >/dev/null
echo "Done"
