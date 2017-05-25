" Vim configuration of Iris Bune
" Last update: 27 December 2017

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible
let mapleader = ','

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
  Plugin 'itchyny/lightline.vim'
  Plugin 'jasoncodes/ctrlp-modified.vim'
  Plugin 'beautify-web/js-beautify'
  Plugin 'kchmck/vim-coffee-script'
  Plugin 'vim-scripts/matchit.zip'
  Plugin 'kana/vim-textobj-user'
  Plugin 'nelstrom/vim-textobj-rubyblock'
  Plugin 'tpope/vim-fugitive'
  Plugin 'tpope/vim-bundler'
  Plugin 'christoomey/vim-tmux-navigator'
  Plugin 'tpope/vim-dispatch'
  Plugin 'thoughtbot/vim-rspec'
call vundle#end()
filetype plugin indent on

set backspace=indent,eol,start  " allow backspacing over everything in IM
set nobackup	    	" do not create backup files (filename~)
set nowritebackup  	" read buffer to original file
set history=50		  " keep 50 lines of command line history
set ruler	        	" show the cursor:column position all the time
set tabstop=2       " 2 spaces for indentation
set smartindent     " indent new line
set shiftwidth=2
set expandtab
set cursorline      " highlight line the cursor is on
set relativenumber  " show line numbers in files
set number          " show current line number
set showcmd	      	" display incomplete commands
set clipboard=unnamed   " use cliplboard anywhere
set noswapfile      " do not create a .swp file
set laststatus=2    " always show the status line

set winwidth=84
set winheight=5
set winminheight=5
set winheight=999

set complete=.,b,u,]
set wildmode=longest,list:longest

" Include Rails directories
set path+=app/**,lib/**,spec/**,config/**,db/**,script/**,elasticsearch/**

" Add suffixes to jump to files
set suffixesadd+=.rb
set includeexpr=substitute(substitute(substitute(v:fname,'::','/','g'),'$','.rb',''),'\(\<\u\l\+\|\l\+\)\(\u\)','\l\1_\l\2','g')

" CtrlP
" ignore stuff that can't be opened, and generated files
let g:fuzzy_ignore = "*.png;*.PNG;*.JPG;*.jpg;*.GIF;*.gif;vendor/**;coverage/**;tmp/**;rdoc/**"

" Panes
" Open new panes on the right/bottom
set splitbelow
set splitright

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax enable
  set background=dark
  colorscheme solarized
  set hlsearch
  set incsearch	    	" do incremental searching

  " Powerline font settings
  set guifont=Liberation\ Mono\ for\ Powerline:h18
  let g:Powerline_symbols = 'fancy'
  set encoding=utf-8
  set fillchars+=stl:\ ,stlnc:\
  set term=xterm-256color
  set termencoding=utf-8
  set noshowmode
endif

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
  \ | wincmd p | diffthis
endif

" Lightline
let g:lightline = {
  \ 'colorscheme': 'solarized',
  \ 'component': {
  \   'readonly': '%{&readonly?"":""}',
  \ },
  \ 'separator': { 'left': '', 'right': '' },
  \ 'subseparator': { 'left': '', 'right': '' }
  \ }

" Git
autocmd Filetype gitcommit setlocal spell textwidth=72

" Rspec
let g:rspec_command = "Dispatch bundle exec spring rspec {spec}"
map <leader>t :call RunCurrentSpecFile()<cr>
map <leader>s :call RunNearestSpec()<cr>
map <leader>l :call RunLastSpec()<cr>
map <leader>a :call RunAllSpecs()<cr>

" Remove trailing whitespace
autocmd BufWritePre * :%s/\s\+$//e

" Mappings
nmap <leader>r :source ~/.vimrc<cr>
nmap <leader>ra :windo :source ~/.vimrc<cr>
imap <Tab> <C-n>
nnoremap <leader>e :e#<cr>

" :noh with just ,h
nmap <leader>h :nohlsearch<cr>
