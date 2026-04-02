#!/usr/bin/env bash
source ~/.dotfiles/data/setup.sh

declare -g g_name='PostgreSQL Anonymizer'
declare -g g_sources_file='/etc/apt/sources.list.d/dalibo-labs.sources'

install.ubuntu() {
	local gpg_file='/etc/apt/keyrings/postgresql-anonymizer.gpg'

	pkg.add_apt_key 'https://apt.dalibo.org/labs/debian-dalibo.gpg' \
		"$gpg_file"

	pkg.add_apt_repository \
		"$g_sources_file" "
			Types: deb
			URIs: http://apt.dalibo.org/labs
			Suites: $(lsb_release -cs)-dalibo
			Components: main
			Architectures: $(dpkg --print-architecture)
			signed-by: $gpg_file"

	sudo apt-get update -y
	sudo apt-get install -y postgresql_anonymizer_18
}

installed() {
	[ -f "$g_sources_file" ] && [ -d /usr/lib/postgresql ]
}

util.if_file_sourced || _setup "$@"
