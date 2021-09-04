========
dotfiles
========

My dotfiles maintained with https://github.com/eankeen/dotty

dotfiles
========

::

	├─ system dotfiles at /
	├─ user dotfiles at ~
	├─ local dotfiles at .

themes
------

Nord
Arcadia


usage
-----

::

	git clone https://github.com/hyperupcall/dots
	cd dots
	git config --local filter.npmrc-clean.clean "$(pwd)/user/config/npm/npmrc-clean.sh"
	git config --local filter.slack-term-config-clean.clean "$(pwd)/user/config/slack-term/slack-term-config-clean.sh"
	git config --local filter.oscrc-clean.clean "$(pwd)/user/config/osc/oscrc-clean.sh"

auxiliary utils
-----

https://github.com/hyperupcall/dots-bootstrap
https://github.com/hyperupcall/dotty
https://github.com/hyperupcall/themer
https://github.com/hyperupcall/fox-default
