# shellcheck shell=bash

if ! command -v 'sdk' &>/dev/null; then
	print.info "Installing sdkman"
	curl -s "https://get.sdkman.io?sdkman_auto_answer=true" | bash
fi
