local chat = require('CopilotChat')

chat.setup({
  panel = {
    enabled = true,             -- Enable the Copilot Chat panel
    auto_refresh = true,        -- Automatically refresh the panel
    keymap = {
      close = '<C-c>',          -- Keybinding to close the panel
      submit = '<C-s>',         -- Keybinding to submit a query
      yank = '<C-y>',           -- Keybinding to yank text
    },
    layout = {
      position = 'right',       -- Position of the chat panel ('left', 'right', 'top', 'bottom')
      size = 40,                 -- Size of the panel (width or height based on position)
    },
  },
  chat = {
    keymap = {
      toggle = '<leader>cc',    -- Keybinding to toggle the chat interface
    },
    -- Additional chat-specific configurations can be added here
  },
  -- You can add more configurations as needed
})
