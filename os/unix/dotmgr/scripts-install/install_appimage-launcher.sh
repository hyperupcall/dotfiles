# shellcheck shell=bash

main() {
	if util.confirm 'Install AppImage Launcher?'; then
		install.appimage_launcher
	fi
}

install.appimage_launcher() {
	term.style_italic -dP 'Not Implemented'
}

main "$@"
