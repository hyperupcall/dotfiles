# shellcheck shell=bash

util.ensure_bin php

hash phpenv &>/dev/null || {
	print.info "Installing phpenv"
	util.req https://raw.githubusercontent.com/phpenv/phpenv-installer/master/bin/phpenv-installer | bash
}
