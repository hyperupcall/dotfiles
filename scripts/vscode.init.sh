#!/bin/sh

help() {
  echo "batch install plugins for vscode"
  echo
  echo "vscode.init.sh 'list of extensions'"
  echo
  echo "flags"
  echo "  --help              display this help menu"
  echo "  --remove-versions    remove versions from extensions"
  echo
  echo "examples"
  echo "  vscode.init.sh --remove-versions \"\$(ls ~/.vscode/extensions)\""
  echo "  vscode.init.sh \"\$(code --list-extensions)\""
}

check_empty() {
  if [ -z "$1" ] || [ -z "$(echo "$1" | sed "s/ //g" | sed "s/\t//g")" ]
  then
    echo "list of extensions is blank. terminating."
    exit 1
  fi
}

if [ "$#" -eq 0 ] || [ "$#" -ge 3 ]
then
  help
  exit 1
fi

if [ "$1" = "--help" ] || [ "$1" = "-h" ]
then
  help
  exit
fi

if [ "$1" = "--remove-versions" ]
then
  check_empty "$2"
  for ext in $2
  do
    code --install-extension "${ext%-*}"
  done
  exit
fi

if [ "$2" = "--remove-versions" ]
then
  check_empty "$1"
  for ext in $1
  do
    code --install-extension "${ext%-*}"
  done  
  exit
fi

check_empty "$1"
for ext in $1
do
  code --install-extension "$ext"
done 
