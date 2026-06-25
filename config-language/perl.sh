#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='Perl'
declare -g g_modules=(
	Term::ReadLine::Perl
	CPAN::DistnameInfo
	Term::ReadKey
	Text::Levenshtein::Damerau::XS
	App::cpanminus
	YAML
)

install.any() {
	cpan install "${g_modules[@]}"
}

install.installed() {
	for module in "${g_modules[@]}"; do
		perl -M"$module" -e 1 &>/dev/null || return 1
	done
}

util.if_file_sourced || _setup "$@"
