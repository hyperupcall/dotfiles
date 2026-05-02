#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='docker secretservice credential store'

install.any() {
	util.get_latest_github_release 'docker/docker-credential-helpers'
	local version="$REPLY"
	echo "$version"
	curl -K "$CURL_CONFIG" -o 'docker-credential-secretservice' "https://github.com/docker/docker-credential-helpers/releases/download/$version/docker-credential-secretservice-$version.linux-amd64"
	chmod +x './docker-credential-secretservice'
	mv './docker-credential-secretservice' "$HOME/.local/bin"

	if [ ! -f "$XDG_CONFIG_HOME/docker/config.json" ]; then
		mkdir -p "$XDG_CONFIG_HOME/docker"
		printf '%s\n' '{}' >"$XDG_CONFIG_HOME/docker/config.json"
	fi

	python -c "import json
import os
from io import StringIO
from pathlib import Path

file = Path(os.environ['XDG_CONFIG_HOME']) / 'docker' / 'config.json'
obj = json.load(StringIO(file.read_text()))
obj['credsStore'] = 'secretservice'
file.write_text(json.dumps(obj, indent='\t'))"
}

install.installed() {
	[ -f "$HOME/.local/bin/docker-credential-secretservice" ]
}

util.if_file_sourced || _setup "$@"
