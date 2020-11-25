#!/bin/sh -au

mount | grep -q binfmt_misc || {
	# see https://www.kernel.org/doc/html/v4.14/admin-guide/binfmt-misc.html
	echo "You don't have binfmt_misc mounted. This configuration is unsupported"
	exit 1
}

file="/proc/sys/fs/binfmt_misc/golang"
[ -e "$file" ] && {
	echo "You already have an 'interpreter' associated with golang. Do 'echo -1 | sudo tee $file' to remove it before running this script."
	cat "$file"
	exit
}
unset -v file

# install gorun
go get github.com/erning/gorun

# add kernel support for executing go files with the gorun 'interpreter'
echo ':golang:E::go::/usr/bin/gorun:OC' | sudo tee /proc/sys/fs/binfmt_misc/register >/dev/null
echo "Done"
