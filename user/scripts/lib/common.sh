# shellcheck shell=sh

die() {
	log_error "$*"
	exit 1
}

req() {
	curl --proto '=https' --tlsv1.2 -sSLf "$@"
}

log_info() {
	printf "\033[0;34m%s\033[0m\n" "INFO: $*"
}

log_error() {
	printf "\033[0;31m%s\033[0m\n" "ERROR: $*" >&2
}
