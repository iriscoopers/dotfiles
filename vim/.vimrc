" Vim configuration

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
  Plugin 'itchyny/lightline.vim'
  Plugin 'edkolev/tmuxline.vim'
  Plugin 'christoomey/vim-tmux-navigator'
  Plugin 'christoomey/vim-tmux-runner'
  Plugin 'junegunn/fzf'
  Plugin 'junegunn/fzf.vim'
  Plugin 'kana/vim-textobj-user'
  Plugin 'nelstrom/vim-textobj-rubyblock'
  Plugin 'tpope/vim-surround'
  Plugin 'vim-ruby/vim-ruby'
  Plugin 'slim-template/vim-slim.git'
  Plugin 'vim-scripts/matchit.zip'
  Plugin 'tpope/vim-fugitive'
  Plugin 'shumphrey/fugitive-gitlab.vim'
  Plugin 'tpope/vim-rhubarb'
  Plugin 'tpope/vim-bundler'
  Plugin 'tpope/vim-rails'
  Plugin 'thoughtbot/vim-rspec'
  Plugin 'beautify-web/js-beautify'
  Plugin 'kchmck/vim-coffee-script'
  Plugin 'leafgarland/typescript-vim'
  Plugin 'pangloss/vim-javascript'
  Plugin 'maxmellon/vim-jsx-pretty'
  Plugin 'posva/vim-vue'
  Plugin 'yaegassy/coc-volar'
  Plugin 'github/copilot.vim'
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
set textwidth=80    " Automatically mode to next line at 80 characters
set expandtab
set cursorline      " highlight line the cursor is on
set relativenumber  " show line numbers in files
set number          " show current line number
set showcmd	      	" display incomplete commands
set clipboard=unnamed   " use cliplboard anywhere
set noswapfile      " do not create a .swp file
set laststatus=2    " always show the status line
set rtp+=/usr/local/opt/fzf
set ma              " Make buffer modifiable

" Highlight part of page when > 80 columns
set colorcolumn=80

" automatically rebalance windows on vim resize
autocmd VimResized * :wincmd =

set complete=.,b,u,]
set wildmode=longest,list:longest

" Include Rails directories
set path+=app/**,lib/**,spec/**,config/**,db/**,script/**,elasticsearch/**

" Add suffixes to jump to files
set suffixesadd+=.rb
set includeexpr=substitute(substitute(substitute(v:fname,'::','/','g'),'$','.rb',''),'\(\<\u\l\+\|\l\+\)\(\u\)','\l\1_\l\2','g')

" Panes
" Open new panes on the right/bottom
set splitbelow
set splitright

" option name default optional
" g:solarized_termcolors= 16 | 256
" g:solarized_termtrans = 0 | 1
" g:solarized_degrade = 0 | 1
" g:solarized_bold = 1 | 0
" g:solarized_underline = 1 | 0
" g:solarized_italic = 1 | 0
" g:solarized_contrast = "normal"| "high" or "low"
" g:solarized_visibility= "normal"| "high" or "low"

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax enable
  set background=light
  colorscheme solarized
  set hlsearch
  set incsearch	    	" do incremental searching

  " Powerline font settings
  set guifont=Literation\ Mono\ Powerline:h18
  let g:Powerline_symbols = 'fancy'
  set encoding=utf-8
  set fillchars+=stl:\ ,stlnc:\
  set term=xterm-256color
  set termencoding=utf-8
  set noshowmode
endif

" Use js highlighting for json files
autocmd BufNewFile,BufRead *.json set ft=javascript

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
  \ 'active': {
  \   'left': [ [ 'mode', 'paste' ],
  \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
  \ },
  \ 'component_function': {
  \   'gitbranch': 'FugitiveHead'
  \ },
  \ }

" Git
autocmd Filetype gitcommit setlocal spell textwidth=72

" Rspec
let project = substitute(getcwd(), '^.*/', '', '')
if project == "rompslomp"
  let g:rspec_command = "VtrSendCommandToRunner be rspec {spec}"
else
  let g:rspec_command = "VtrSendCommandToRunner be spring rspec {spec}"
endif

map <leader>t :call RunCurrentSpecFile()<cr>
map <leader>s :call RunNearestSpec()<cr>
map <leader>l :call RunLastSpec()<cr>
map <leader>a :call RunAllSpecs()<cr>

" Without Spring
map <leader>ft :call RunCurrentSpecFile()<cr>
map <leader>fs :call RunNearestSpec()<cr>
map <leader>fl :call RunLastSpec()<cr>
map <leader>fa :call RunAllSpecs()<cr>

" Remove trailing whitespace
autocmd BufWritePre * :%s/\s\+$//e

" Mappings
nmap <leader>r :source ~/.vimrc<cr>
nmap <leader>ra :windo :source ~/.vimrc<cr>
nmap <leader>x :Explore<cr>
nnoremap <leader>e :e#<cr> " Open previously edited file

" :noh with just ,h
nmap <leader>h :nohlsearch<cr>

" Vim Tmux Runner
"         Mapping      |   Command
"        -----------------------------
"        <leader>rr   |   VtrResizeRunner<cr>
"        <leader>ror  |   VtrReorientRunner<cr>
"        <leader>sc   |   VtrSendCommandToRunner<cr>
"        <leader>sl   |   VtrSendLinesToRunner<cr>
"        <leader>or   |   VtrOpenRunner<cr>
"        <leader>kr   |   VtrKillRunner<cr>
"        <leader>fr   |   VtrFocusRunner<cr>
"        <leader>dr   |   VtrDetachRunner<cr>
"        <leader>ar   |   VtrReattachRunner<cr>
"        <leader>cr   |   VtrClearRunner<cr>
"        <leader>fc   |   VtrFlushCommand<cr>
let g:VtrUseVtrMaps = 1
nnoremap <leader>ap :VtrAttachToPane<cr>
nnoremap <leader>sc :VtrSendCommandToRunner<cr>
nnoremap <leader>fc :VtrFlushCommand<cr>
nnoremap <leader>ar :VtrReattachRunner<cr>
nnoremap <leader>nr :VtrOpenRunner {'orientation': 'h', 'percentage': 30}<cr>

let g:fzf_layout = { 'window': { 'width': 1, 'height': 0.6, 'yoffset': 1, 'border': 'horizontal' } }
" fzf with rg
" --column: Show column number
" --line-number: Show line number
" --no-heading: Do not show file headings in results
" --fixed-strings: Search term as a literal string
" --ignore-case: Case insensitive search
" --no-ignore: Do not respect .gitignore, etc...
" --hidden: Search hidden files and folders
" --follow: Follow symlinks
" --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
" --color: Search color options

let g:rg_command = 'rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --color "always" -g "*.{js,json,haml,md,styl,pug,jade,html,config,py,cpp,c,go,hs,rb,conf,fa,lst,slim,coffee,scss,sass,vue,xls,xlsx,csv,rake,lib,kt}" -g "!{.config,.git,node_modules,vendor,build,yarn.lock,*.sty,*.bst,dist,log,tmp}/*" '
command! -bang -nargs=* Find call fzf#vim#grep(g:rg_command.shellescape(<q-args>).'| tr -d "\017"', 1, <bang>0)

" Use rg instead of grep, see https://dev.to/iggredible/how-to-search-faster-in-vim-with-fzf-vim-36ko#other-searches
set grepprg=rg\ --vimgrep\ --smart-case\ --follow

" Search files
nnoremap <C-p> :Files<CR>
" Search in files
nnoremap <C-f> :Find
" Search buffers
nnoremap <C-b> :Buffers<CR>

" Ctags
nnoremap <leader>tt :!Ctags -R<cr>

" Rails
nnoremap <leader>rc :Rails console<cr>

" Golang
let g:go_fmt_command = "goimports"

" Gitlab Rompslomp
let g:fugitive_gitlab_domains = ['https://gitlab.rompslomp.nl']

" Github Copilot

