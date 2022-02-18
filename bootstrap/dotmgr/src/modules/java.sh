# shellcheck shell=bash

util.ensure_bin java
util.ensure_bin sdk
util.ensure_bin mvn
util.ensure_bin gradle

if ! command -v 'sdk' &>/dev/null; then
	print.info "Installing sdkman"
	curl -s "https://get.sdkman.io?sdkman_auto_answer=true" | bash
fi

if [ ! -d ~/.dots/.repos/maven-bash-completion ]; then
	git clone https://github.com/juven/maven-bash-completion ~/.dots/.repos/maven-bash-completion
fi
