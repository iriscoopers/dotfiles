-- Set nocompatible mode
vim.opt.compatible = false

-- Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ','
vim.g.localmapleader = ','

-- Don't show mode, since it's already in the status bar
vim.opt.showmode = false

-- Enable filetype detection and plugins
vim.cmd('filetype plugin indent on')

-- Initialize vim-plug
vim.cmd('source ~/.config/nvim/plugins.vim')

-- Load vim-rails after filetype detection
vim.cmd('runtime! plugin/rails.vim')

-- Debug vim-rails loading
vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    vim.notify('vim-rails loaded: ' .. tostring(vim.fn.exists(':Rails')))
    vim.notify('vim-rails functions: ' .. tostring(vim.fn.exists('*rails#app')))
  end
})

-- Load configurations
require('theme')
require('mappings')
require('telescope_config')
require('treesitter_config')
require('cmp_config')
require('lsp')
require('copilot_chat')
require('command_references')
-- Load rails_config last to ensure it doesn't override other settings
require('rails_config')

-- General settings
vim.o.backspace = "indent,eol,start"     -- Allow backspacing over everything in insert mode
vim.o.backup = false                     -- Do not create backup files
vim.o.writebackup = false                -- Do not create a backup before overwriting a file
vim.o.history = 50                       -- Keep 50 lines of command line history
vim.o.ruler = true                       -- Show the cursor position all the time
vim.o.tabstop = 2                        -- Number of spaces a tab counts for
vim.o.shiftwidth = 2                     -- Number of spaces to use for each step of (auto)indent
vim.o.smartindent = true                 -- Smart auto-indenting on new lines
vim.o.textwidth = 100                    -- Automatically wrap text at 100 characters
vim.o.expandtab = true                   -- Use spaces instead of tabs
vim.o.cursorline = true                  -- Highlight the line with the cursor
vim.o.relativenumber = true              -- Show relative line numbers
vim.o.number = true                      -- Show absolute line number on the cursor line (when relative number is on)
vim.o.showcmd = true                     -- Display incomplete commands
vim.o.swapfile = false                   -- Do not use swapfile
vim.o.laststatus = 2                     -- Always display the status line
vim.o.ma = true                          -- Make buffer modifiable
vim.o.complete = ".,b,u,]"               -- Command-line completion settings
vim.o.wildmode = "longest,list:longest"  -- Command-line completion mode
vim.o.splitbelow = true                  -- Open new horizontal pane to the bottom
vim.o.splitright = true                  -- Open new vertical pane to the right
vim.opt.clipboard = 'unnamedplus'        -- Use the clipboard for all operations
vim.opt.inccommand = 'split'             -- Preview substitutions live, as you type!
vim.opt.colorcolumn = "100"              -- Highlight column at 100 characters
vim.opt.rtp:append("/usr/local/opt/fzf") -- Add fzf to runtime path
vim.opt.foldmethod = "expr"              -- Fold based on indent level
vim.opt.foldexpr = "nvim_treesitter#foldexpr()" -- Use treesitter for folding
vim.opt.foldlevel = 99                   -- Open all folds by default
vim.opt.ignorecase = true                -- Case-insensitive search
vim.opt.smartcase = true                 -- Override ignorecase if search pattern has uppercase
vim.opt.termguicolors = true             -- Enable 24-bit RGB color
vim.opt.undofile = true                  -- Persistent undo history
vim.opt.signcolumn = "yes"               -- Always show sign column for Git/LSP signs

-- Autocommands
-- Automatically rebalance windows on vim resize
vim.api.nvim_create_autocmd("VimResized", {
    pattern = "*",
    command = "wincmd ="
})

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Remove trailing whitespace
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  command = ":%s/\\s\\+$//e",
})

-- Reload changed files automatically
vim.api.nvim_create_autocmd({"FocusGained", "BufEnter"}, {
  pattern = "*",
  command = ":checktime"
})

-- Setup LSP diagnostic symbols
local signs = { Error = " ", Warn = " ", Hint = "󰌵 ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end
