# shellcheck shell=bash

# Name:
# Install Docker Credential Secret Service

main() {
	if util.confirm "Install docker secretservice credential store version v0.6.4?"; then
		local version='v0.6.4'

		util.cd_temp

		curl -o 'docker-credential-secretservice.tar.gz' "https://github.com/docker/docker-credential-helpers/releases/download/$version/docker-credential-secretservice-$version-amd64.tar.gz"
		tar xf 'docker-credential-secretservice.tar.gz'
		mv './docker-credential-secretservice' "$HOME/bin"

		popd >/dev/null

		python -c "import json
import os
from io import StringIO
from pathlib import Path

file = Path(os.environ['XDG_CONFIG_HOME']) / 'docker' / 'config.json'
obj = json.load(StringIO(file.read_text()))
obj['credsStore'] = 'secretservice'
file.write_text(json.dumps(obj, indent='\t'))"
	fi
}

main "$@"
