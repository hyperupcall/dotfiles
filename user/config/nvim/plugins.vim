" Download VimPlug if it doesn't exist
let plugFile = xdgDataHome.'/nvim/site/autoload/plug.vim'
if empty(plugFile)
	silent execute '!curl -fLo '.plugFile.' --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin(xdgDataHome.'/nvim/vim-plug-plugins')
" START SCREEN
Plug 'mhinz/vim-startify'
Plug 'arp242/startscreen.vim'


" STATUS BAR
Plug 'vim-airline/vim-airline'
" Plug 'powerline/powerline'
" Plug 'itchyny/lightline.vim'


" FILE BROWSER
Plug 'preservim/nerdtree'
" Plug 'lambdalisue/fern.vim'
" Plug 'tpope/vim-vinegar'
" Plug 'justinmk/vim-dirvish'


" LANGUAGES / INTELLISENSE
Plug 'neovim/nvim-lspconfig'
Plug 'neoclide/coc.nvim', #{branch: 'release'}
Plug 'hrsh7th/nvim-compe'

" BUFFER EDITING
Plug 'AndrewRadev/splitjoin.vim'
Plug 'jiangmiao/auto-pairs'
" Plug 'tpope/vim-commentary'
Plug 'preservim/nerdcommenter'
" Plug 'tpope/vim-surround'
Plug 'Raimondi/delimitMate'


" NEW BUFFERS
Plug 'preservim/tagbar'
Plug 'ctrlpvim/ctrlp.vim'


" NEW COMMANDS
Plug 'tpope/vim-eunuch'

" THEMES
Plug 'drewtempelmeyer/palenight.vim'
Plug 'morhetz/gruvbox'
Plug 'arcticicestudio/nord-vim'
Plug 'lifepillar/vim-solarized8'
Plug 'vim-airline/vim-airline-themes'


" SNIPPETS
" Plug 'SirVer/ultisnips'
" Plug 'lervag/vimtex'
" Plug 'honza/vim-snippets'
" Plug 'mattn/emmet-vim'


" VCS
Plug 'airblade/vim-gitgutter'


" MISC
" Plug 'airblade/vim-rooter'
" Plug 'tpope/vim-obsession'
" Plug 'ycm-core/YouCompleteMe'
Plug 'tpope/vim-sleuth'
Plug 'luochen1990/rainbow'
Plug 'wincent/terminus'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'ryanoasis/vim-devicons'
Plug 'antoinemadec/FixCursorHold.nvim'
Plug 'lambdalisue/suda.vim'
call plug#end()

