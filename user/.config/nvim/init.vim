let xdgConfigHome = exists('$XDG_CONFIG_HOME') ? $XDG_CONFIG_HOME : $HOME.'/.config'
let xdgDataHome = exists('$XDG_DATA_HOME') ? $XDG_DATA_HOME : $HOME.'/.local/data'
let xdgStateHome = exists('$XDG_STATE_HOME') ? $XDG_STATE_HOME : $HOME.'/.local/state'
let xdgCacheHome = exists('$XDG_CACHE_HOME') ? $XDG_CACHE_HOME : $HOME.'/.cache'

execute 'source' xdgConfigHome.'/nvim/plugin-manager/plug/plugins.vim'
" execute 'source' xdgConfigHome.'/nvim/lsp.lua'

" lua require('plugins')

silent! colorscheme gruvbox
set number

" Required for NerdCommenter
filetype plugin on

filetype plugin indent on
" set tabstop=8
" set shiftwidth=8


" NerdCommenter
let g:NERDCreateDefaultMappings = 1
let g:NERDSpaceDelims = 1

" Committia
let g:committia_hooks = {}
" if !exists("*g:committia_hooks.edit_open")
" function! g:committia_hooks.edit_open(info)
    " " Additional settings
    " setlocal spell

    " " If no commit message, start with insert mode
    " if a:info.vcs ==# 'git' && getline(1) ==# ''
	" startinsert
    " endif

    " " Scroll the diff window from insert mode
    " " Map <C-n> and <C-p>
    " imap <buffer><C-n> <Plug>(committia-scroll-diff-down-half)
    " imap <buffer><C-p> <Plug>(committia-scroll-diff-up-half)
" endfunction
" endif

" NerdTree
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1

nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
" nnoremap <C-f> :NERDTreeFind<CR>
nnoremap <C-y> "+y
vnoremap <C-y> "+y

" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" Open the existing NERDTree on each new tab.
" autocmd BufWinEnter * if getcmdwintype() == '' | silent NERDTreeMirror | endif

" If the first argument is a directory, cd to it; if it's a file, cd to it's parent directory
if argc() == 1 && !exists('s:std_in')
	let arg0 = argv()[0]
	if isdirectory(arg0)
		execute 'cd '.arg0
	else
		" dirname(arg0)
		let dirr = '/'.join(split(arg0, '/')[:-2], '/')
		execute 'cd '.dirr
	endif
endif

" TagBar
nmap <F8> :TagbarToggle<CR>

" if !exists("*DoSov")
" 	function DoSov() abort
" 		source $MYVIMRC
" 	endfunction
" endif
" command Sov call DoSov()
