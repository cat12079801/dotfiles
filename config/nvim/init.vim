"basic ---------------------------------
set number

"lightline.vim ---------------------------------
let g:lightline = {
\ 'colorscheme': 'wombat'
\ }

let s:dein_dir = expand('~/.cache/dein')
let s:toml_dir = expand('~/.config/nvim')

"dein Scripts-----------------------------
if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=/home/cat/.cache/dein/repos/github.com/Shougo/dein.vim

" Required:
if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  " Immediate load
  call dein#load_toml(s:toml_dir . '/dein.toml', {'lazy': 0})

  " Lazy load
  call dein#load_toml(s:toml_dir . '/dein_lazy.toml', {'lazy': 1})

  " Required:
  call dein#end()
  call dein#save_state()
endif

" Required:
filetype plugin indent on
syntax enable

" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif

"End dein Scripts-------------------------
