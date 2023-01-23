# shellcheck shell=bash

{
	util.clone_in_dots 'https://github.com/marvinkreis/rofi-json-menu'
	make
	sudo make install
}
