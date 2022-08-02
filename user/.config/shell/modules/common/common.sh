# shellcheck shell=bash

foxxy() {
	deno run --unstable --allow-run --allow-env --allow-read --allow-write --allow-net "$HOME/repos/foxxy/output/bundle.js" "$@"
}

foxxy-dev() {
	deno run --unstable --allow-run --allow-env --allow-read --allow-write --allow-net "$HOME/repos/foxxy/src/main.ts" "$@"
}
