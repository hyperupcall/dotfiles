# shellcheck shell=bash

if ! util.is_cmd 'pyenv'; then
	util.log_info "Installing pyenv"
	util.req https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash
fi

pyenv install 3.10.0 || :
pyenv global 3.10.0

if ! util.is_cmd 'pip'; then
	util.log_info "Installing pip"
	python3 -m ensurepip --upgrade
fi
python3 -m pip install --upgrade pip

pip3 install wheel


if ! util.is_cmd 'pipx'; then
	util.log_info "Installing pipx"
	python3 -m pip install --user pipx
	python3 -m pipx ensurepath
fi

if ! util.is_cmd 'poetry'; then
	util.log_info "Installing poetry"
	util.req https://install.python-poetry.org | python3 -
fi
