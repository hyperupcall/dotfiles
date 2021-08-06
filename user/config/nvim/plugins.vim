

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
Plug 'vim-crystal/vim-crystal'

" BUFFER EDITING
Plug 'AndrewRadev/splitjoin.vim'
Plug 'jiangmiao/auto-pairs'
" Plug 'tpope/vim-commentary'
Plug 'preservim/nerdcommenter'
" Plug 'tpope/vim-surround'
" Plug 'Raimondi/delimitMate'


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
" Plug 'editorconfig/editorconfig-vim'
Plug 'tpope/vim-sleuth'
Plug 'iamcco/markdown-preview.nvim'
Plug 'luochen1990/rainbow'
Plug 'wincent/terminus'
Plug 'tpope/vim-repeat'
Plug 'junegunn/vim-slash'
Plug 'pgdouyon/vim-evanesco'
Plug 'junegunn/vader.vim'
Plug 'vim-test/vim-test'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'ryanoasis/vim-devicons'
Plug 'rhysd/committia.vim'
Plug 'antoinemadec/FixCursorHold.nvim'
Plug 'lambdalisue/suda.vim'
Plug 'mileszs/ack.vim'
Plug 'keith/investigate.vim'
Plug 'editorconfig/editorconfig-vim'
" Plug 'vim-markdown'
Plug 'jiangmiao/auto-pairs'
Plug 'vimwiki/vimwiki'
Plug 'zah/nim.vim'
" Plug 'shougo/deoplete.nvim'
" Plug 'airblade/vim-gitgutter'
" Plug 'w0rp/ale'
" Plug 'valloric/youcompleteme'
" Plug 'mattn/emmet-vim'
call plug#end()
