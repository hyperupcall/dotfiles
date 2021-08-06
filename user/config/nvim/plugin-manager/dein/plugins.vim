" If you want to install not installed plugins on startup.
"if dein#check_install()
"  call dein#install()
"endif

set runtimepath+=/home/edwin/.cache/dein/repos/github.com/Shougo/dein.vim

call dein#begin('/home/edwin/.cache/dein')

call dein#add('/home/edwin/.cache/dein/repos/github.com/Shougo/dein.vim')
call dein#add('mbbill/undotree')
call dein#add('Yggdroot/indentLine')

call dein#end()


filetype plugin indent on
syntax enable
