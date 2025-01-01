-- Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ','
vim.g.localmapleader = ','

-- Don't show mode, since it's already in the status bar
vim.opt.showmode = false

-- Initialize vim-plug
vim.cmd('source ~/.config/nvim/plugins.vim')

-- Include configurations
require('theme')
require('mappings')
require('telescope_config')
require('treesitter_config')
require('cmp_config')
require('lsp')
require('copilot_chat')

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
