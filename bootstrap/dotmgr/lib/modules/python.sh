# shellcheck shell=bash

check_bin python
check_bin pip
check_bin poetry
check_bin pyenv
check_bin pipx
check_bin bpython

hash pyenv &>/dev/null || {
	util.log_info "Installing pyenv"
	util.req https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash
}

# ensure installation: libffi-devel
pyenv install 3.9.0
pyenv global 3.9.0

hash poetry &>/dev/null || {
	util.log_info "Installing poetry"
	util.req https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python -
}

hash pipx &>/dev/null || {
	python3 -m pip install --user pipx
}

hash conda &>/dev/null || {
    # TODO
    	cd "$(mktemp -d)"
	util.req -O https://repo.anaconda.com/miniconda/Miniconda3-py39_4.9.2-Linux-x86_64.sh
	bash * -s -- -p "$XDG_DATA_HOME/miniconda3"
	cd -
}
