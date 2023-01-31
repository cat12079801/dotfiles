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
nnoremap <silent><leader>r :source $MYVIMRC<CR>
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

" ファイルツリー
Plug 'preservim/nerdtree'

" 行末の空白を可視化
Plug 'ntpeters/vim-better-whitespace'

" gitの変更状態を可視化(左端に表示する)
Plug 'airblade/vim-gitgutter'

" カラーコードをその色で表示する
Plug 'norcalli/nvim-colorizer.lua'

" LSP
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'

call plug#end()
"vim-plug ----------------------------------


" plugin settings ------------------------------------
colorscheme nightfox

" 現在開いているファイルをハイライトしつつNERDTreeを開く
nnoremap <C-f> :NERDTreeFind<CR>

" 末尾の空白を可視化する色の指定
let g:better_whitespace_ctermcolor='red'
let g:better_whitespace_guicolor='#99142a'

" GitGutter の更新を即座に行うため(GitGutterが100を推奨)
set updatetime=100
" SignColumng(左端)に表示するgitの状態の記号と色の設定
let g:gitgutter_sign_added    = '●'
let g:gitgutter_sign_modified = '●'
let g:gitgutter_sign_removed  = '●'
highlight SignColumn                    guibg=#212c3b
highlight GitGutterAdd    guifg=#45c474 guibg=#212c3b
highlight GitGutterChange guifg=#e2e835 guibg=#212c3b
highlight GitGutterDelete guifg=#e82e4d guibg=#212c3b
" 次/前のハンクへ移動
nmap gn <Plug>(GitGutterNextHunk)
nmap gp <Plug>(GitGutterPrevHunk)

" norcalli/nvim-colorizer.lua に必要
" One line setup. This will create an autocmd for FileType * to highlight every filetype.
" NOTE: You should add this line after/below where your plugins are setup.
lua require'colorizer'.setup()
" plugin settings ------------------------------------
