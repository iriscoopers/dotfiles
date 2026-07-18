-- kulala.nvim -- HTTP client for .http/.rest files.
-- Useful for poking at .NET and Rails APIs without leaving the editor.

local kulala_ok, kulala = pcall(require, 'kulala')
if not kulala_ok then
  return
end

kulala.setup({
  -- Show the response in a split rather than replacing the current window.
  display_mode = 'split',
  -- Keep the request/response buffers around after running.
  default_view = 'body',
})

-- .http and .rest files are the ones kulala operates on.
vim.filetype.add({
  extension = {
    http = 'http',
    rest = 'http',
  },
})

-- Buffer-local keymaps, so they only exist in HTTP buffers and cannot clash
-- with the Ruby/C# mappings. Namespaced under <leader>H rather than <leader>h:
-- <leader>h is :nohlsearch, and any <leader>h* mapping would stall it for a
-- full timeoutlen (1000ms) on every use.
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'http',
  group = vim.api.nvim_create_augroup('kulala-keymaps', { clear = true }),
  callback = function()
    local function map(lhs, rhs, desc)
      vim.keymap.set('n', lhs, rhs, { buffer = true, silent = true, desc = desc })
    end

    map('<leader>Hs', function() require('kulala').run() end, 'Send request under cursor')
    map('<leader>Ha', function() require('kulala').run_all() end, 'Send all requests in file')
    map('<leader>Hr', function() require('kulala').replay() end, 'Replay last request')
    map('<leader>Hi', function() require('kulala').inspect() end, 'Inspect current request')
    map('<leader>Hc', function() require('kulala').copy() end, 'Copy request as curl')
    map('<leader>Hn', function() require('kulala').jump_next() end, 'Next request')
    map('<leader>Hp', function() require('kulala').jump_prev() end, 'Previous request')
    map('<leader>Ht', function() require('kulala').toggle_view() end, 'Toggle body/headers view')
    map('<leader>Hq', function() require('kulala').close() end, 'Close kulala windows')
  end,
})

-- Scratchpad is not tied to an HTTP buffer, so it gets a global mapping.
vim.keymap.set('n', '<leader>Hb', function() require('kulala').scratchpad() end,
  { silent = true, desc = 'Open kulala scratchpad' })
