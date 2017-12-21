" -----------------------------------------------
"                    VIMRC!
" -----------------------------------------------
scriptencoding utf-8
set nocompatible

" --- use lang C
language mes C

" --- Release keymaps
nnoremap <Space> <Nop>
nnoremap . <Nop>
nnoremap ' <Nop>


" //////////////////// dein.vim ////////////////////
" プラギン置き場
let s:dein_dir = expand('~/.vim/dein')

" dein.vim の本体
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

" dein.vim が無い時は取ってくる
if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
endif

if dein#load_state(s:dein_dir)
  " >>>>> START dein
  call dein#begin(s:dein_dir)

  "TOML files
  let g:rc_dir = s:dein_dir . '/repos/github.com/yyatsuo/vimrc'
  let s:toml   = g:rc_dir . '/dein.toml'

  "Caching
  call dein#load_toml(s:toml, {'lazy':0})

  call dein#end()
  call dein#save_state()
  " <<<<< END dein
endif

" ないものがあったら取ってくる
if dein#check_install()
  call dein#install()
endif



" //////////////// general settings ////////////////
set number
set expandtab
set ls=2
set shiftwidth=2
set showcmd
set incsearch
set tabstop=2
set smartindent
set autoindent
set autoread
set autowrite
set encoding=utf-8
set fileencodings=utf-8,iso-2022-jp,cp932,euc-jp,shift-jis,default,latin,EUC-UCS2
set ignorecase

" GUI Options
set guioptions-=m " Hide Menubar 
set guioptions-=T " Hide Toolbar

" Where to store .swp files
set directory=$HOME/.vim/bk

" Show special chars
set list
set listchars=tab:>\ ,trail:-

" Status line
let &statusline='%F%m%r%h%w [FORMAT=%{&ff}] [ENC=%{&fileencoding}] [TYPE=%Y] [ASCII=\%03.3b] [HEX=\%02.2B] [POS=%04l,%04v][%p%%] [LEN=%L]'


" かわいい は せいぎ
syntax on 

" //////////////////// hlsearch ////////////////////
set hlsearch
function! ToggleHighlight()
    if(&hlsearch)
        set nohlsearch
    else
        set hlsearch
    endif
endfunction


" //////////////////// keymaps ////////////////////
" Space + . --- edit .vimrc
nnoremap <silent> <Space>.
\       :<C-u>edit $MYVIMRC<CR>

" Space + , --- reload .vimrc
nnoremap <silent> <Space>,
\       :<C-u>source $MYVIMRC<CR>

" Space + h --- toggle highlight
nnoremap <silent> <Space>h
\       :call ToggleHighlight()<CR>

" Ctrl W + A --- split horizontal
noremap <silent> <C-w><C-a>
\       :split<CR>

" Space + ] --- Make tag file
noremap <Space>] 
\       :<C-u>!ctags -R -V<CR>

" Ctrl + c + t --- open new tab
noremap <silent><C-c><C-t>
\       :tabnew<CR>

" Ctrl + c + n --- movet to next tab
noremap <silent><C-c><C-n>
\       :tabnext<CR>

" Ctrl + c + c --- move to previous tab
noremap <silent><C-c><C-p>
\       :tabprevious<CR>

" Ctrl + c + c --- Close current tab
noremap <silent><C-c><C-c>
\       :tabclose<CR>

" Ctrl + u --- Smooth scroll up
map <C-U> <C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y>

" Ctrl + d --- Smooth scroll down
map <C-D> <C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E>


" !!!!! Noli me tangere !!!!!
" どっかからパクッた文字コードの自動認識
if &encoding !=# 'utf-8'
  set encoding=japan
  set fileencoding=japan
endif
if has('iconv')
  let s:enc_euc = 'euc-jp'
  let s:enc_jis = 'iso-2022-jp'
  " iconvがeucJP-msに対応しているかをチェック
  if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'eucjp-ms'
    let s:enc_jis = 'iso-2022-jp-3'
  " iconvがJISX0213に対応しているかをチェック
  elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'euc-jisx0213'
    let s:enc_jis = 'iso-2022-jp-3'
  endif
  " fileencodingsを構築
  if &encoding ==# 'utf-8'
    let s:fileencodings_default = &fileencodings
    let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
    let &fileencodings = &fileencodings .','. s:fileencodings_default
    unlet s:fileencodings_default
  else
    let &fileencodings = &fileencodings .','. s:enc_jis
    set fileencodings+=utf-8,ucs-2le,ucs-2
    if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
      set fileencodings+=cp932
      set fileencodings-=euc-jp
      set fileencodings-=euc-jisx0213
      set fileencodings-=eucjp-ms
      let &encoding = s:enc_euc
      let &fileencoding = s:enc_euc
    else
      let &fileencodings = &fileencodings .','. s:enc_euc
    endif
  endif
  " 定数を処分
  unlet s:enc_euc
  unlet s:enc_jis
endif
" 日本語を含まない場合は fileencoding に encoding を使うようにする
if has('autocmd')
  function! AU_ReCheck_FENC()
    if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
      let &fileencoding=&encoding
    endif
  endfunction
  autocmd BufReadPost * call AU_ReCheck_FENC()
endif
" 改行コードの自動認識
set fileformats=unix,dos,mac
" □とか○の文字があってもカーソル位置がずれないようにする
if exists('&ambiwidth')
  set ambiwidth=double
endif

