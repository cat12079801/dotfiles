"basic ---------------------------------
set number
set cursorline
set tabstop=2
set expandtab
set shiftwidth=2
set softtabstop=2
set smartindent
set list
set listchars=tab:»-,trail:_,extends:»,precedes:«,nbsp:%
set conceallevel=0
set signcolumn=yes
let mapleader = ','
"basic ---------------------------------


"prefix --------------------------------
nmap ; :Buffers<CR>
nmap f :Files<CR>
nmap <C-p> <C-^>
"prefix --------------------------------


"change tabstop by extension ------------------------------
if has("autocmd")
  "登録されていないファイルタイプを登録
  autocmd BufRead,BufNewFile *.ts   setfiletype typescript
  "ファイルタイプの検索を有効にする
  filetype plugin on
  "ファイルタイプに合わせたインデントを利用
  filetype indent on
  "sw=softtabstop, sts=shiftwidth, ts=tabstop, et=expandtabの略
  autocmd FileType python      setlocal sw=4 sts=4 ts=4 et
  autocmd FileType javascript  setlocal sw=4 sts=4 ts=4 et
  autocmd FileType go          setlocal sw=4 sts=4 ts=4 noet
  autocmd FileType typescript  setlocal sw=4 sts=4 ts=4 et
endif
"change tabstop by extension ------------------------------


"python for neovim ------------------------------
let g:python_host_prog = $HOME . '/.pyenv/versions/neovim2/bin/python'
let g:python3_host_prog = $HOME . '/.pyenv/versions/neovim3/bin/python'
"python for neovim ------------------------------


" dein ---------------------------------
let s:dein_dir = expand('~/.cache/dein')
let s:toml_dir = expand('~/.config/nvim')
" dein ---------------------------------

"dein Scripts-----------------------------
if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim

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
"dein Scripts-----------------------------
