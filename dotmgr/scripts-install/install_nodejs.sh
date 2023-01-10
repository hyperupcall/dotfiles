# shellcheck shell=bash

main() {
	if util.confirm 'Install NPM packages?'; then
		core.print_info 'Installing NPM Packages'
		npm i -g yarn pnpm
		yarn global add pnpm
		yarn global add diff-so-fancy
		yarn global add npm-check-updates
		yarn global add graphqurl
		yarn global add http-server
	fi
}
