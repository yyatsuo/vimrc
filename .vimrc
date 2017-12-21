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
set hlsearch
set incsearch
set tabstop=2
set smartindent
set autoindent

syntax on                  "かわいい は せいぎ
