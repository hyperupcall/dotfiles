#!/bin/sh

help() {
	cat 0<<-EOF
		    vscode.init.sh:
		      batch install plugins for vscode

		    Flags
		      --help              display this help menu
		      --remove-versions    remove versions from extensions

		    Examples
		      vscode.init.sh --remove-versions "\$(ls ~/.vscode/extensions)"
		      vscode.init.sh "\$(code --list-extensions)"
	EOF
}

check_empty() {
	if [ -z "$1" ] || [ -z "$(echo "$1" | sed "s/ //g" | sed "s/\t//g")" ]; then
		echo "list of extensions is blank. terminating."
		exit 1
	fi
}

if [ "$#" -eq 0 ] || [ "$#" -ge 3 ]; then
	help
	exit 1
fi

if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
	help
	exit 0
fi

if [ "$1" = "--remove-versions" ]; then
	check_empty "$2"
	for ext in $2; do
		code --install-extension "${ext%-*}"
	done
	exit
fi

if [ "$2" = "--remove-versions" ]; then
	check_empty "$1"
	for ext in $1; do
		code --install-extension "${ext%-*}"
	done
	exit
fi

check_empty "$1"
for ext in $1; do
	code --install-extension "$ext"
done
