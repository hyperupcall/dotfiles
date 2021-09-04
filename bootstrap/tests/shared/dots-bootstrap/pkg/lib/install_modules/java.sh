# shellcheck shell=bash

check_bin java
check_bin sdk
check_bin mvn
check_bin gradle

hash sdk &>/dev/null || {
	log_info "Installing sdkman"
	curl -s "https://get.sdkman.io?sdkman_auto_answer=true" | bash
}

# TODO
# git clone https://github.com/juven/maven-bash-completion
