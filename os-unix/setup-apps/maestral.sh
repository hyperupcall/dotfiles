#!/usr/bin/env bash
source ~/.dotfiles/os-unix/data/setup.sh

declare -g g_name='Maestral'

main() {
	util.install_by_setup "$@"
}

install.debian() {
	sudo apt-get install -y python3-dev python3-venv cython libsystemd-dev pkg-config qt5-default
	sudo apt-get install -y libxcb-cursor0 # maestral gui
	install_maestral "$@"
}

install.ubuntu() {
	sudo apt-get install -y python3-dev python3-venv cython3 libsystemd-dev pkg-config
	sudo apt-get install -y libxcb-cursor0 # maestral gui
	install_maestral "$@"
}

install.neon() {
	sudo apt-get install -y python3-dev python3-venv cython3 libsystemd-dev pkg-config qt5-default
	sudo apt-get install -y libxcb-cursor0 # maestral gui
	install_maestral "$@"
}

install.fedora() {
	sudo dnf install -y python3 python3-devel cython systemd-devel pkg-config qt5-qtbase-devel
}

install.opensuse() {
	sudo zypper -n install python311 python-devel python311-cython systemd-devel pkg-config libqt5-qtbase-devel
	install_maestral "$@"
}

install.arch() {
	sudo pacman -Syu --noconfirm python3 pkg-config
}

install_maestral() {
	mkdir -p ~/.dotfiles/.data/maestral
	cd ~/.dotfiles/.data/maestral
	~/scripts/setup/python-tools.sh --no-confirm

	if [ -f ./venv/bin/activate ]; then
		core.print_info 'Found virtualenv'
	else
		core.print_info 'Creating virtualenv'
		python3 -m venv ./venv
	fi
	source ./venv/bin/activate

	python3 -m pip --require-virtualenv install --upgrade pip
	python3 -m pip --require-virtualenv install --upgrade wheel
	python3 -m pip --require-virtualenv install --upgrade importlib_metadata # Fedora 39
	python3 -m pip --require-virtualenv install --upgrade maestral
	python3 -m pip --require-virtualenv install --upgrade 'maestral[gui]'
	python3 -m pip --require-virtualenv install --upgrade 'maestral[syslog]' # May fail

	mkdir -p ~/.dotfiles/.data/bin
	cat <<'EOF' > ~/.dotfiles/.data/bin/maestral
#!/usr/bin/env sh
set -e
. ~/.dotfiles/.data/maestral/venv/bin/activate
maestral "$@"
EOF
	chmod +x ~/.dotfiles/.data/bin/maestral

	maestral auth link
	mkdir -p ~/Documents/Dropbox
	maestral config set path ~/Documents/Dropbox
	maestral autostart --yes
	maestral start
}

installed() {
	command -v maestral &>/dev/null
}

util.if_file_sourced || _setup "$@"
