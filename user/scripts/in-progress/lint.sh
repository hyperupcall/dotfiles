#!/usr/bin/env sh

check() {
	script='file'

	eslint
	editorconfig-checker
	bash -n "$script"
	fish -n  "$script"
	zsh -n "$script"

	ansible-playbook --syntax-check
	vagrant validate ./**/Vagrantfile
	crystal tool format --check
	nimble check
	rustfmt
	json5 --validate
}

format() {
	terraform fmt
}

lint() {
	:
}
