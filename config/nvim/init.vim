set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath=&runtimepath
source ~/.vimrc

lua require("init")

set clipboard=unnamedplus

inoremap <C-c> <Esc>`^
