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
  Plug 'rose-pine/neovim', { 'as': 'rose-pine' }
  Plug 'nvim-lualine/lualine.nvim'
  Plug 'edkolev/tmuxline.vim'

  " Tmux <3 Vim
  Plug 'christoomey/vim-tmux-navigator'
  Plug 'christoomey/vim-tmux-runner'

  " Searching
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'nvim-telescope/telescope-fzf-native.nvim', {'do': 'make'}

  " LSPs
  Plug 'neovim/nvim-lspconfig'
  Plug 'folke/trouble.nvim'              " Better diagnostics UI

  " Auto-completion
  Plug 'hrsh7th/nvim-cmp'          " Completion plugin
  Plug 'hrsh7th/cmp-nvim-lsp'      " LSP source for nvim-cmp
  Plug 'hrsh7th/cmp-buffer'        " Buffer completions
  Plug 'hrsh7th/cmp-path'          " Path completions
  Plug 'L3MON4D3/LuaSnip'          " Snippet engine
  Plug 'saadparwaiz1/cmp_luasnip'  " Snippet completions

  " Ruby/Rails
  Plug 'tpope/vim-rails'
  Plug 'vim-ruby/vim-ruby'
  Plug 'tpope/vim-endwise'         " Auto-add end in Ruby
  Plug 'slim-template/vim-slim'    " Slim template support
  Plug 'tpope/vim-bundler'
  Plug 'ngmy/vim-rubocop'          " Rubocop integration
  Plug 'thoughtbot/vim-rspec'      " RSpec integration

  " Tree-sitter
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'nvim-treesitter/nvim-treesitter-textobjects'

  " Git integration
  Plug 'tpope/vim-fugitive'

  " AI
  Plug 'MunifTanjim/nui.nvim'           " UI component library required by neoai
  Plug 'Bryley/neoai.nvim'         " OpenAI integration for Neovim

  " Advanced text editing
  Plug 'tpope/vim-surround'        " Surroundings manipulation
  Plug 'tpope/vim-repeat'          " Enhanced . repeat
  Plug 'AndrewRadev/splitjoin.vim' " Split/join lines
call plug#end()
