# shellcheck shell=bash

declare -a modules
readarray -t modules <<< "$(
	find "$DIR/lib/install_modules" -mindepth 1 -maxdepth 1 -type f -printf "%P\n"
)"

if [[ -n $1 ]]; then
	found_module=no
	for module in "${modules[@]}"; do
		module="${module%.sh}"

		[[ $1 == "$module" ]] && {
			log_info "Executing install_modules/$module.sh"
			source "$DIR/lib/install_modules/$module.sh"
			found_module=yes
		}
	done

	[[ $found_module == no ]] && die "module '$1' not found"
# if we want to execute all modules
else
	for module in "${modules[@]}"; do
		log_info "Executing install_modules/$module"
		source "$DIR/lib/install_modules/$module"
	done
fi
