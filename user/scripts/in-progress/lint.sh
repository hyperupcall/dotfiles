#!/usr/bin/env sh

check() {
	script='file'

	editorconfig-checker
	bash -n "$script"

	ansible-playbook --syntax-check
	vagrant validate ./**/Vagrantfile
	crystal tool format --check
        nimble check
}

format() {
	terraform fmt
}

lint() {
	:
}
