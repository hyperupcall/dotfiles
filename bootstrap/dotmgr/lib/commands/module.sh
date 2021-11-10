# shellcheck shell=bash

declare module="$1"

if [ -f "$ROOT_DIR/lib/modules/$module.sh" ]; then
	source "$ROOT_DIR/lib/modules/$module.sh"
else
	printf '%s\n' "Module '$module' not found"
fi
