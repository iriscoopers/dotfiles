call plug#begin()
" The default plugin directory will be as follows:
"   - Vim (Linux/macOS): '~/.vim/plugged'
"   - Vim (Windows): '~/vimfiles/plugged'
"   - Neovim (Linux/macOS/Windows): stdpath('data') . '/plugged'
" You can specify a custom plugin directory by passing it as the argument
"   - e.g. `call plug#begin('~/.vim/plugged')`
"   - Avoid using standard Vim directory names like 'plugin'

" Make sure you use single quotes
  " Style
  Plug 'altercation/vim-colors-solarized'
  Plug 'itchyny/lightline.vim'
  Plug 'edkolev/tmuxline.vim'

  " Tmux <3 Vim
  Plug 'christoomey/vim-tmux-navigator'
  Plug 'christoomey/vim-tmux-runner'

  Plug 'junegunn/fzf'
  Plug 'junegunn/fzf.vim'
  Plug 'kana/vim-textobj-user'
  " Plug 'nelstrom/vim-textobj-rubyblock'
  " Plug 'tpope/vim-surround'

  " Language highlighting
  " Plug 'vim-ruby/vim-ruby'

  " Extending %
  Plug 'vim-scripts/matchit.zip'
  " Rails
  Plug 'tpope/vim-fugitive'
  Plug 'shumphrey/fugitive-gitlab.vim'
  Plug 'tpope/vim-rhubarb'
  Plug 'tpope/vim-bundler'
  " Plug 'tpope/vim-rails'
  Plug 'thoughtbot/vim-rspec'

  Plug 'mfussenegger/nvim-dap' "debugging

  " Javascript
  Plug 'beautify-web/js-beautify'
  Plug 'leafgarland/typescript-vim'
  Plug 'pangloss/vim-javascript'
  Plug 'maxmellon/vim-jsx-pretty'

  " LSP in vim
  Plug 'neovim/nvim-lspconfig'
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'hrsh7th/nvim-cmp'
  Plug 'L3MON4D3/LuaSnip'
  Plug 'VonHeikemen/lsp-zero.nvim', {'branch': 'v3.x'}
  "Plug 'neoclide/coc.nvim', {'branch': 'release'}

  " AI
  Plug 'github/copilot.vim'
call plug#end()
