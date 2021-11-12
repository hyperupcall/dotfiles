# shellcheck shell=bash

declare flag_{list,show}='no'
for arg; do case "$arg" in
	--list) shift; flag_list='yes' ;;
	--show) shift; flag_show='yes' ;;
esac done
declare module="$1"

if [ "$flag_list" = 'yes' ]; then
	for file in "$DOTMGR_ROOT_DIR/lib/modules/"*; do
		file="${file##*/}"
		file="${file%.sh}"
		printf '%s  ' "$file"
	done; unset file

	printf '\n'
	return
fi

if [ -f "$DOTMGR_ROOT_DIR/lib/modules/$module.sh" ]; then
	if [ "$flag_show"  = 'yes' ]; then
		printf '%s\n' "$(<"$DOTMGR_ROOT_DIR/lib/modules/$module.sh")"
	else
		source "$DOTMGR_ROOT_DIR/lib/modules/$module.sh" "$@"
	fi
else
	printf '%s\n' "Module '$module' not found"
fi
