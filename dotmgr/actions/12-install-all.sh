# shellcheck shell=bash

# Name:
# Install All
#
# Description:
# Installs all programs and packages. Some are installed through package
# managers while others are installed manually

main() {
	dotmgr.call '30-install_packages.sh'
	dotmgr.call '31-install_others.sh'
	dotmgr.call '32-update-others.sh'
	dotmgr.call '33-install-browser-extensions.sh'
}
