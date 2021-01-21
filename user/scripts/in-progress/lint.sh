#!/usr/bin/env sh

check() {
	editorconfig-checker
	bash -n "$script"

	ansible-playbook --syntax-check
	vagrant validate ./**/Vagrantfile
	crystal tool format --check
}

format() {
	terraform fmt
}

lint() {
	:
}
