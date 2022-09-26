# shellcheck shell=bash

foxxo() {
	deno run --unstable --allow-run --allow-env --allow-read --allow-write --allow-net "$HOME/repos/foxxo/output/bundle.js" "$@"
}

foxxo-dev() {
	deno run --unstable --allow-run --allow-env --allow-read --allow-write --allow-net "$HOME/repos/foxxo/src/main.ts" "$@"
}
