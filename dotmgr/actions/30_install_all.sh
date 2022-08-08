# shellcheck shell=bash

# Name:
# Install All
#
# Description:
# Installs all programs and packages. Some are installed through package
# managers while others are installed manually

main() {
	dotmgr.call '30_install_packages.sh'
	dotmgr.call '31_install_others.sh'
	dotmgr.call '32_update_others.sh'
	dotmgr.call '33_install_browser_extensions.sh'
}
