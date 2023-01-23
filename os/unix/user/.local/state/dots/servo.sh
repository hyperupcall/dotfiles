# shellcheck shell=sh

# Arch Linux has append_path set in /etc/profile
p='/usr/lib/servo'

case ":$PATH:" in
	*:"$p":*) ;;
	*) PATH="${PATH:+$PATH:}$p"
esac
