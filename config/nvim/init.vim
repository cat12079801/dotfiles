"basic ---------------------------------
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
set pumblend=15
set termguicolors
set clipboard=unnamed
set foldmethod=manual
set ignorecase
set scrolloff=10
let mapleader = ','
"basic ---------------------------------


"key maps --------------------------------

"key maps --------------------------------


"change tabstop by extension ------------------------------
if has("autocmd")
  "登録されていないファイルタイプを登録
  autocmd BufRead,BufNewFile *.ts   setfiletype typescript
  autocmd BufRead,BufNewFile *.log   setfiletype log
  "ファイルタイプの検索を有効にする
  filetype plugin on
  "ファイルタイプに合わせたインデントを利用
  filetype indent on
  "sw=softtabstop, sts=shiftwidth, ts=tabstop, et=expandtabの略
  autocmd FileType python      setlocal sw=4 sts=4 ts=4 et
  autocmd FileType go          setlocal sw=4 sts=4 ts=4 noet
  " autocmd FileType typescript  setlocal sw=4 sts=4 ts=4 et
  autocmd FileType php         setlocal sw=4 sts=4 ts=4 et
  autocmd FileType markdown    setlocal sw=4 sts=4 ts=4 conceallevel=0
  autocmd FileType json        setlocal conceallevel=0

  autocmd FileType vue syntax sync fromstart
endif
"change tabstop by extension ------------------------------

"vim-plug ----------------------------------
call plug#begin()

" vimのステータスライン
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" カラースキーマ
Plug 'EdenEast/nightfox.nvim'

call plug#end()
"vim-plug ----------------------------------

colorscheme nightfox
