#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	if util.confirm 'Setup Albert?'; then
		setup.albert
	fi
}

setup.albert() {
	cat <<EOF > "$XDG_CONFIG_HOME/autostart/albert.desktop"
[Desktop Entry]
Categories=Utility;
Comment=A desktop agnostic launcher
Exec=bash -c 'env LD_LIBRARY_PATH="/usr/local/lib:$HOME/Qt/6.6.1/gcc_64/lib" /usr/local/bin/albert --platform xcb; sleep 9; /usr/local/bin/albert restart'
GenericName=Launcher
Icon=albert
Name=Albert
StartupNotify=false
Type=Application
Version=1.0
# Give desktop environments time to init. Otherwise QGnomePlatform does not correctly pick up the palette.
X-GNOME-Autostart-Delay=3
EOF

}

main "$@"


