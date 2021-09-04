# shellcheck shell=bash

declare -a modules
readarray -t modules <<< "$(
	find "$DIR/lib/install_modules" -mindepth 1 -maxdepth 1 -type f -printf "%P\n"
)"

if [[ -n $1 ]]; then
	found_module=no
	for module in "${modules[@]}"; do
		module="${module%.sh}"

		if [[ $1 == "$module" ]]; then
			log_info "Executing install_modules/$module.sh"
			source "$DIR/lib/install_modules/$module.sh"
			found_module=yes
		fi
	done

	if [ "$found_module" == no ]; then
		die "module '$1' not found"
	fi
# if we want to execute all modules
else
	for module in "${modules[@]}"; do
		log_info "Executing install_modules/$module"
		source "$DIR/lib/install_modules/$module"
	done
fi
