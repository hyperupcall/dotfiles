# shellcheck shell=bash

util.ensure_bin php

if ! command -v 'phpenv' &>/dev/null; then
	print.info "Installing phpenv"
	util.req https://raw.githubusercontent.com/phpenv/phpenv-installer/master/bin/phpenv-installer | bash
fi
