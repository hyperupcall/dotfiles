# shellcheck shell=bash

main() {
	if util.confirm 'Install Sublime Text?'; then
		install.sublime_text
	fi
}

install.sublime_text() {
	term.style_italic -dP 'Not Implemented'
}
