#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/setup.sh

declare -g g_name='Dotdrop'

main() {
	cd ~/.dotfiles/.data/

	if [ -d ./dotdrop ]; then
		core.print_info 'Found dotdrop repository'
	else
		core.print_info 'Downloading dotdrop repository'
		util.clone ./dotdrop https://github.com/deadc0de6/dotdrop
	fi
	cd ./dotdrop
	if [ -f ./venv/bin/activate ]; then
		core.print_info 'Found virtualenv'
	else
		core.print_info 'Creating virtualenv'
		python3 -m venv ./venv
	fi
	source ./venv/bin/activate

	python3 -m pip install --upgrade pip
	python3 -m pip install --upgrade wheel
	python3 -m pip install -r ./requirements.txt

	mkdir -p ~/.dotfiles/.data/bin
	cat <<'EOF' > ~/.dotfiles/.data/bin/dotdrop
	#!/usr/bin/env sh
	set -e
	. ~/.dotfiles/.data/dotdrop/repository/venv/bin/activate
	~/.dotfiles/.data/dotdrop/repository/dotdrop.sh "$@"
EOF
	chmod +x ~/.dotfiles/.data/bin/dotdrop
}
