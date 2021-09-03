" Download VimPlug if it doesn't exist
let plugFile = xdgDataHome.'/nvim/site/autoload/plug.vim'

if empty(glob(plugFile))
	silent execute '!mkdir -p '.fnamemodify(plugFile, ':h')
	silent execute '!curl -fLo '.plugFile.' https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
