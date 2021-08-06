" Download VimPlug if it doesn't exist
let plugFile = xdgDataHome.'/nvim/site/autoload/plug.vim'
if empty(plugFile)
	silent execute '!curl -fLo '.plugFile.' --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
