call plug#begin('~/data/vim/vim-plug-plugins')
	Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
   Plug 'junegunn/fzf.vim'
	Plug 'airblade/vim-gitgutter'
	Plug 'w0rp/ale'
	Plug 'valloric/youcompleteme'
	Plug 'mattn/emmet-vim'

	" Plug 'vim-scripts/sudo.vim'
	Plug 'lambdalisue/suda.vim'
	Plug 'ryanoasis/vim-devicons'
	Plug 'ctrlpvim/ctrlp.vim'
	Plug 'shougo/deoplete.nvim'

	" status bar
	Plug 'itchyny/lightline.vim'

	let g:NERDTreeBookmarksFile=expand("$XDG_DATA_HOME/vim/NERDTreeBookmarks")
        let g:NERDTreeChDirMode = 2
	Plug 'preservim/nerdtree'
	Plug 'preservim/nerdcommenter'
	Plug 'preservim/tagbar'

	Plug 'tpope/vim-sensible'
	" Plug 'tpope/vim-commentary'
	Plug 'tpope/vim-surround'
	Plug 'tpope/vim-markdown'

        " formatting
        Plug 'editorconfig/editorconfig-vim'

        " linting

	" syntax
	Plug 'plasticboy/vim-markdown'
	Plug 'zah/nim.vim'

	" misc
	" Plug 'jiangmiao/auto-pairs'
	" Plug 'vimwiki/vimwiki'

call plug#end()
