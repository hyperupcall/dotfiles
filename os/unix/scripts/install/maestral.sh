# shellcheck shell=bash

source "${0%/*}/../source.sh"

mkdir -p ~/.dotfiles/.data/workspace/maestral
util.cd ~/.dotfiles/.data/workspace/maestral

if [ -d ./venv ]; then
	core.print_info 'Found virtualenv'
else
	core.print_info 'Creating virtualenv'
	python3 -m venv ./venv
fi
source ./venv/bin/activate

python3 -m pip install --upgrade wheel
python3 -m pip install --upgrade maestral 'maestral[gui]'
python3 -m pip install --upgrade 'maestral[syslog]' # May fail

maestral autostart --yes

cat <<'EOF' > ~/.dotfiles/.data/bin/maestral
#!/usr/bin/env sh
set -e
. ~/.dotfiles/.data/workspace/maestral/venv/bin/activate
maestral "$@"
EOF
chmod +x ~/.dotfiles/.data/bin/maestral
