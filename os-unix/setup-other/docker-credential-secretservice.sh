#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

declare -g g_name='docker secretservice credential store version v0.6.4'

main() {
	local version='v0.6.4'
	curl -K "$CURL_CONFIG" -o 'docker-credential-secretservice.tar.gz' "https://github.com/docker/docker-credential-helpers/releases/download/$version/docker-credential-secretservice-$version-amd64.tar.gz"
	tar xf 'docker-credential-secretservice.tar.gz'
	mv './docker-credential-secretservice' "$HOME/bin"

	python -c "import json
import os
from io import StringIO
from pathlib import Path

file = Path(os.environ['XDG_CONFIG_HOME']) / 'docker' / 'config.json'
obj = json.load(StringIO(file.read_text()))
obj['credsStore'] = 'secretservice'
file.write_text(json.dumps(obj, indent='\t'))"
}

installed() {
	[ -f ~/bin/docker-credential-secretservice ]
}

util.if_file_sourced || _setup "$@"
