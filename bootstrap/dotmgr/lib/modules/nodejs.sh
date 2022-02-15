# shellcheck shell=bash

if ! command -v n &>/dev/null; then
	util.log_info "Installing n"
	util.req https://raw.githubusercontent.com/mklement0/n-install/stable/bin/n-install | bash
fi

npm i -g yarn
yarn global add pnpm
yarn global add diff-so-fancy
yarn global add npm-check-updates
yarn global add graphqurl

# yarn config set prefix "$XDG_DATA_HOME/yarn"
