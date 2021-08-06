" " "d represents good default
" set autoindent "d
" set autoread "d
" set autowrite
" set background=dark
" set backspace=indent,eol,start "d
" set backup
" let &backupdir=expand("$XDG_DATA_HOME/vim/backup")
" set belloff=all
" set nobomb
" set cmdheight=1
" set clipboard=unnamedplus
" set complete-=i "d
" set confirm
" set nocursorline " Highlight the line on which the cursor lives.
" let &directory=expand("$XDG_DATA_HOME/vim/swap")
" set display+=lastline "d
" " set display=truncate "d
" " set encoding=utf-8 "d
" if &encoding ==# 'latin1' && has('gui_running')
"   set encoding=utf-8
" endif
" set noerrorbells
" set noexpandtab

" if v:version > 703 || v:version == 703 && has("patch541")
" 	set formatoptions+=j " Delete comment character when joining commented lines
" endif
" set fileformats=unix,dos,mac
" set hidden
" set history=10000 "d
" set hlsearch "d
" set ignorecase
" set incsearch "d
" if has('reltime') "d
"   set incsearch
" endif
" set laststatus=2 "d
" set lazyredraw
" " if &listchars ==# 'eol:$'
" "   set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
" " endif
" set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:␣
" set nolist
" set magic
" set matchtime=2
" set modeline
" "set modifiable
" set mouse=a
" " In many terminal emulators the mouse works just fine.  By enabling it you
" " can position the cursor, Visually select and scroll with the mouse.
" " Only xterm can grab the mouse events when using the shift key, for other
" " terminals use ":", select text and press Esc.
" if has('mouse')
"   if &term =~ 'xterm'
"     set mouse=a
"   else
"     set mouse=nvi
"   endif
" endif
" set nrformats-=octal "s
" set number
" set relativenumber
" set ruler "s
" set sessionoptions-=options "s
" set scrolloff=1 "s
" set shiftwidth=8
" set showcmd "d
" set showmatch
" set noshowmode " If lightline/airline is enabled, don't show mode under it
" set sidescrolloff=5 "s
" set smartcase
" set smartindent
" set smarttab "s
" set suffixes+=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc
" set t_vb= "no sound on errors
" set tabpagemax=50 "s
" set tabstop=8
" set notimeout
" set timeoutlen=500
" if !has('nvim')
"   set ttimeout
"   set ttimeoutlen=100
" endif
" set title
" set ttyfast
" let &undodir=expand("$XDG_DATA_HOME/vim/undo")
" set viewoptions-=options "s
" let &viminfo="%,<800,'10,/50,:100,h,f0,n" . expand("$XDG_DATA_HOME/vim/viminfo")
" "           | |    |   |   |    | |  + viminfo file path
" "           | |    |   |   |    | + file marks 0-9,A-Z 0=NOT stored
" "           | |    |   |   |    + disable 'hlsearch' loading viminfo
" "           | |    |   |   + command-line history saved
" "           | |    |   + search history saved
" "           | |    + files marks saved
" "           | + lines saved each register (old name for <, vi6.2)
" "           + save/restore buffer list
" set novisualbell
" set wildignore+=*.o,*~,*.pyc
" set wildmenu "s
" set wrap
