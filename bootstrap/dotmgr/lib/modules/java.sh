# shellcheck shell=bash

util.ensure_bin java
util.ensure_bin sdk
util.ensure_bin mvn
util.ensure_bin gradle

hash sdk &>/dev/null || {
	util.log_info "Installing sdkman"
	curl -s "https://get.sdkman.io?sdkman_auto_answer=true" | bash
}

# TODO
# git clone https://github.com/juven/maven-bash-completion
