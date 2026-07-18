-- Key mappings
vim.api.nvim_set_keymap('n', '<leader>r', ':source ~/.config/nvim/init.lua<CR>:echo "Neovim config reloaded!"<CR>', { noremap = true, silent = false })
-- <leader>R, not <leader>ra: rails_config.lua loads after this file and binds
-- <leader>ra to :Emailer, which would silently win.
vim.api.nvim_set_keymap('n', '<leader>R', ':windo :source ~/.config/nvim/init.lua<CR>:echo "Neovim config reloaded in all windows!"<CR>', { noremap = true, silent = false })
vim.api.nvim_set_keymap('n', '<leader>x', ':Explore<CR>', { noremap = true, silent = true }) -- file explorer

vim.api.nvim_set_keymap('i', '<C-c>', '<Esc>`^', { noremap = true }) -- Get back to normal mode
vim.api.nvim_set_keymap('n', '<leader>h', ':nohlsearch<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>e', ':e#<CR>', { noremap = true, silent = true })

-- Key mappings for clipboard operations
-- Copy to clipboard
vim.api.nvim_set_keymap('v', '<leader>y', '"+y', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>yy', '"+yy', { noremap = true, silent = true })

-- Paste from clipboard
vim.api.nvim_set_keymap('n', '<leader>p', '"+p', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>P', '"+P', { noremap = true, silent = true })

-- Key mappings for telescope
vim.api.nvim_set_keymap('n', '<leader>ff', "<cmd>lua require('telescope.builtin').find_files()<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fg', "<cmd>lua require('telescope.builtin').live_grep()<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fb', "<cmd>lua require('telescope.builtin').buffers()<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fh', "<cmd>lua require('telescope.builtin').help_tags()<cr>", { noremap = true, silent = true })

-- Vim Tmux Runner -- maps set by the plugin when VtrUseVtrMaps = 1
--   Mapping      |   Command
--  -----------------------------
--  <leader>va   |   VtrAttachToPane
--  <leader>ror  |   VtrReorientRunner   (reorient/resize the pane)
--  <leader>sc   |   VtrSendCommandToRunner
--  <leader>sl   |   VtrSendLinesToRunner
--  <leader>sf   |   VtrSendFile
--  <leader>or   |   VtrOpenRunner
--  <leader>kr   |   VtrKillRunner
--  <leader>fr   |   VtrFocusRunner
--  <leader>dr   |   VtrDetachRunner
--  <leader>cr   |   VtrClearRunner
--  <leader>fc   |   VtrFlushCommand
-- There is no VtrResizeRunner command; VtrReorientRunner is the closest.
-- <leader>ap, <leader>ar and <leader>nr are set below, not by the plugin.

-- Set global variable
vim.g.VtrUseVtrMaps = 1

-- Key mappings
vim.api.nvim_set_keymap('n', '<leader>ap', ':VtrAttachToPane<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>sc', ':VtrSendCommandToRunner<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fc', ':VtrFlushCommand<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>ar', ':VtrReattachRunner<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>nr', ":VtrOpenRunner {'orientation': 'h', 'percentage': 30}<CR>", { noremap = true, silent = true })

