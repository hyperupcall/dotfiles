# shellcheck shell=bash

check_bin node
check_bin yarn
check_bin pnpm

# todo: remove prompt
hash node &>/dev/null || {
	util.log_info "Installing n"
	util.req https://raw.githubusercontent.com/mklement0/n-install/stable/bin/n-install | bash
}

npm i -g yarn
yarn global add pnpm
yarn global add diff-so-fancy
yarn global add @eankeen/cliflix
yarn global add npm-check-updates
yarn global add graphqurl
yarn global add nb.sh
yarn global add json5

yarn config set prefix "$XDG_DATA_HOME/yarn"
