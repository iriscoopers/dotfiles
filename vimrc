" Vim configuration of Iris Bune
" Last update: 27 December 2017

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" Vundle
filetype off              " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
  " let Vundle manage Vundle, required
  Plugin 'VundleVim/Vundle.vim'
  Plugin 'altercation/vim-colors-solarized'
  Plugin 'vim-ruby/vim-ruby'
  Plugin 'slim-template/vim-slim.git'
  Plugin 'ctrlpvim/ctrlp.vim'
  Plugin 'vim-airline/vim-airline'
  Plugin 'vim-airline/vim-airline-themes'
call vundle#end()
filetype plugin indent on

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set nobackup	    	" do not create backup files (filename~)
set nowritebackup  	" read buffer to original file
set history=50		  " keep 50 lines of command line history
set ruler	        	" show the cursor:column position all the time
set tabstop=2       " 2 spaces for indentation
set smartindent     " indent new line 
set shiftwidth=2
set expandtab
set cursorline      " highlight line the cursor is on
set number          " show line numbers in files
set showcmd	      	" display incomplete commands
set incsearch	    	" do incremental searching
set clipboard=unnamed   " use cliplboard anywhere
set noswapfile      " do not create a .swp file
set laststatus=2    " always show the status line

" Include Rails directories
set path+=app/**,lib/**,spec/**,config/**,db/**,script/**,elasticsearch/**

" Add suffixes to jump to files
set suffixesadd+=.rb
set includeexpr=substitute(substitute(substitute(v:fname,'::','/','g'),'$','.rb',''),'\(\<\u\l\+\|\l\+\)\(\u\)','\l\1_\l\2','g')

" CtrlP
" ignore stuff that can't be opened, and generated files
let g:fuzzy_ignore = "*.png;*.PNG;*.JPG;*.jpg;*.GIF;*.gif;vendor/**;coverage/**;tmp/**;rdoc/**"

" Don't use Ex mode, use Q for formatting
" map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
" inoremap <C-U> <C-G>u<C-U>

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax enable
  set background=dark
  colorscheme solarized
  set hlsearch
endif

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

" Airline
let g:airline_powerline_fonts = 1
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_symbols.space = "\ua0"
let g:airline_theme='molokai'
  
