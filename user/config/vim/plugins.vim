call plug#begin('~/data/vim/vim-plug-plugins')
	Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
   Plug 'junegunn/fzf.vim'
	Plug 'preservim/nerdtree'
	Plug 'airblade/vim-gitgutter'
	Plug 'w0rp/ale'
	Plug 'valloric/youcompleteme'
	Plug 'mattn/emmet-vim'


	" syntax
	Plug 'plasticboy/vim-markdown'
	Plug 'zah/nim.vim'

call plug#end()
