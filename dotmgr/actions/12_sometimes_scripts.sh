# shellcheck shell=bash

# Name:
# Sometimes scripts
#
# Description:
# Executes scripts that should only be ran sometimes

main() {
	if util.confirm "Install docker secretservice credential store?"; then
		(
			local dir=
			dir=$(mktemp -d)
			cd "$dir" || exit 1

			curl -o 'docker-credential-secretservice.tar.gz' "https://github.com/docker/docker-credential-helpers/releases/download/v0.6.4/docker-credential-secretservice-v0.6.4-amd64.tar.gz"
			tar xf 'docker-credential-secretservice.tar.gz'
			mv './docker-credential-secretservice.tar.gz' "$HOME/bin"
		)
		python -c "import json
import os
from io import StringIO
from pathlib import Path

file = Path(os.environ['XDG_CONFIG_HOME']) / 'docker' / 'config.json'
obj = json.load(StringIO(file.read_text()))
obj['credsStore'] = 'secretservice'
file.write_text(json.dumps(obj, indent='\t'))
"
	fi

	if util.config "Copy password store to dropbox?"; then
		cp -r "$XDG_SHARE_HOME"/password-store/* "$HOME/Dropbox/password-store"
	fi
}
