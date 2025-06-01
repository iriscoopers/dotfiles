-- Key mappings
vim.api.nvim_set_keymap('n', '<leader>r', ':source ~/.config/nvim/init.lua<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>ra', ':windo :source ~/.config/nvim/init.lua<CR>', { noremap = true, silent = true })
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

-- Vim Tmux Runner
--   Mapping      |   Command
--  -----------------------------
--  <leader>rr   |   VtrResizeRunner<cr>
--  <leader>ror  |   VtrReorientRunner<cr>
--  <leader>sc   |   VtrSendCommandToRunner<cr>
--  <leader>sl   |   VtrSendLinesToRunner<cr>
--  <leader>or   |   VtrOpenRunner<cr>
--  <leader>kr   |   VtrKillRunner<cr>
--  <leader>fr   |   VtrFocusRunner<cr>
--  <leader>dr   |   VtrDetachRunner<cr>
--  <leader>ar   |   VtrReattachRunner<cr>
--  <leader>cr   |   VtrClearRunner<cr>
--  <leader>fc   |   VtrFlushCommand<cr>

-- Set global variable
vim.g.VtrUseVtrMaps = 1

-- Key mappings
vim.api.nvim_set_keymap('n', '<leader>ap', ':VtrAttachToPane<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>sc', ':VtrSendCommandToRunner<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fc', ':VtrFlushCommand<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>ar', ':VtrReattachRunner<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>nr', ":VtrOpenRunner {'orientation': 'h', 'percentage': 30}<CR>", { noremap = true, silent = true })

-- Toggle Copilot Chat
vim.api.nvim_set_keymap('n', '<leader>cc', ':CopilotChatToggle<CR>', { noremap = true, silent = true })
