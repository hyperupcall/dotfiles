# shellcheck shell=bash

dotmgr-module() {
	local flag_{list,show,edit}='no'
	for arg; do case $arg in
		--list) shift; flag_list='yes' ;;
		--show) shift; flag_show='yes' ;;
		--edit) shift; flag_edit='yes' ;;
	esac done
	local module="$1"

	if [ "$flag_list" = 'yes' ]; then
		for file in "$DOTMGR_ROOT/src/modules/"*; do
			file="${file##*/}"
			file="${file%.sh}"
			printf '%s  ' "$file"
		done; unset file

		printf '\n'
		return
	fi

	if [ -z "$module" ]; then
		core.print_die 'Name of module stage cannot be empty'
	fi

	if [ -f "$DOTMGR_ROOT/src/modules/$module.sh" ]; then
		if [ "$flag_show" = 'yes' ]; then
			printf '%s\n' "$(<"$DOTMGR_ROOT/src/modules/$module.sh")"
		elif [ "$flag_edit" = 'yes' ]; then
			"$EDITOR" "$DOTMGR_ROOT/src/modules/$module.sh"
		else
			source "$DOTMGR_ROOT/src/modules/$module.sh" "$@"
		fi
	else
		printf '%s\n' "Module '$module' not found"
	fi
}
