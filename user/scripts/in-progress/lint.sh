#!/usr/bin/env sh

check() {
	editorconfig-checker
	bash -n "$script"

	ansible-playbook --syntax-check
	vagrant validate ./**/Vagrantfile
}

format() {
	terraform fmt
}

lint() {
	:
}
