# shellcheck shell=sh

# Arch Linux has no prepend_path set in /etc/profile
p='/usr/lib/jvm/default/bin'

case ":$PATH:" in
	*:"$p":*) ;;
	*) PATH="$p${PATH:+:$PATH}"
esac
