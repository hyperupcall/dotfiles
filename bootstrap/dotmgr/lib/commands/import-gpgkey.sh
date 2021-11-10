# shellcheck shell=bash

declare dir="$1"

: "${dir:=/storage/ur/storage_other/gnupg}"

gpg --homedir "$dir" --armor --export-secret-key | gpg --import
