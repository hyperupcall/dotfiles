# shellcheck shell=bash

check_bin php

hash phpenv &>/dev/null || {
	log_info "Installing phpenv"
	req https://raw.githubusercontent.com/phpenv/phpenv-installer/master/bin/phpenv-installer | bash
}
