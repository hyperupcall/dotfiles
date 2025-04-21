if [ -d "$XDG_DATA_HOME/miniconda3/bin" ]; then
	_util_path_prepend "$XDG_DATA_HOME/miniconda3/bin"
	eval "$(conda shell.bash hook)"
fi
