# shellcheck shell=bash

check_bin php

hash phpenv &>/dev/null || {
	util.log_info "Installing phpenv"
	util.req https://raw.githubusercontent.com/phpenv/phpenv-installer/master/bin/phpenv-installer | bash
}
