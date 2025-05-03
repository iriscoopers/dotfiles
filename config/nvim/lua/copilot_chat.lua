local chat = require('CopilotChat')

-- Function to get selected text
local function get_selected_text()
  local start_pos = vim.api.nvim_buf_get_mark(0, '<')
  local end_pos = vim.api.nvim_buf_get_mark(0, '>')
  local start_row, start_col = start_pos[1], start_pos[2]
  local end_row, end_col = end_pos[1], end_pos[2]
  local lines = vim.api.nvim_buf_get_lines(0, start_row - 1, end_row, false)
  if #lines == 0 then return "" end
  lines[1] = string.sub(lines[1], start_col + 1)
  if #lines == 1 then
    lines[1] = string.sub(lines[1], 1, end_col - start_col + 1)
  else
    lines[#lines] = string.sub(lines[#lines], 1, end_col + 1)
  end
  return table.concat(lines, '\n')
end

-- Function to handle visual mode commands
local function handle_visual_command(command)
  local text = get_selected_text()
  if text ~= "" then
    -- Store the selected text in a register
    vim.fn.setreg('"', text)
    -- Execute the command with the selected text
    vim.cmd(command)
  end
end

-- CopilotChat setup with enhanced features
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
      size = 40,                -- Size of the panel (width or height based on position)
    },
  },
  chat = {
    keymaps = {
      close = '<C-c>',
      reset = '<C-r>',
      submit = '<CR>',
      accept = '<A-y>',
      yank = '<C-y>',
      clear = '<C-l>',
    },
    toggle = '<leader>cc',    -- Keybinding to toggle the chat interface
  },
  selection = {
    keymaps = {
      submit = '<CR>',
      replace = 'r',
      copy = 'y',
    },
  },
  prompts = {
    -- Preset prompts for common tasks
    Explain = {
      prompt = "Explain how this code works in detail."
    },
    FixCode = {
      prompt = "Review this code for bugs or errors and suggest fixes."
    },
    Optimize = {
      prompt = "Optimize this code for better performance and readability."
    },
    CompleteFunction = {
      prompt = "Complete this function according to its name and existing context."
    },
    DocumentCode = {
      prompt = "Add comprehensive documentation to this code including method descriptions and parameters."
    },
    Rails = {
      prompt = "Analyze this Rails code and provide best practices and improvements."
    },
    Rubocop = {
      prompt = "Identify any Rubocop issues in this code and suggest fixes to make it comply with Ruby style guidelines."
    },
    RSpec = {
      prompt = "Create RSpec tests for this code following best testing practices."
    }
  }
})

-- Set up keymaps for predefined prompts
vim.keymap.set("n", "<leader>ce", "<cmd>CopilotChatExplain<cr>", { desc = "Explain Code" })
vim.keymap.set("n", "<leader>cf", "<cmd>CopilotChatFixCode<cr>", { desc = "Fix Code" })
vim.keymap.set("n", "<leader>co", "<cmd>CopilotChatOptimize<cr>", { desc = "Optimize Code" })
vim.keymap.set("n", "<leader>cd", "<cmd>CopilotChatDocumentCode<cr>", { desc = "Document Code" })
vim.keymap.set("n", "<leader>cr", "<cmd>CopilotChatRails<cr>", { desc = "Rails Best Practices" })
vim.keymap.set("n", "<leader>cs", "<cmd>CopilotChatRSpec<cr>", { desc = "Generate RSpec Tests" })
vim.keymap.set("n", "<leader>cb", "<cmd>CopilotChatRubocop<cr>", { desc = "Fix Rubocop Issues" })

-- Set up visual mode keymaps with custom handling
vim.keymap.set("v", "<leader>ce", function() handle_visual_command("CopilotChatExplain") end, { desc = "Explain Code" })
vim.keymap.set("v", "<leader>cf", function() handle_visual_command("CopilotChatFixCode") end, { desc = "Fix Code" })
vim.keymap.set("v", "<leader>co", function() handle_visual_command("CopilotChatOptimize") end, { desc = "Optimize Code" })
vim.keymap.set("v", "<leader>cd", function() handle_visual_command("CopilotChatDocumentCode") end, { desc = "Document Code" })
vim.keymap.set("v", "<leader>cr", function() handle_visual_command("CopilotChatRails") end, { desc = "Rails Best Practices" })
vim.keymap.set("v", "<leader>cs", function() handle_visual_command("CopilotChatRSpec") end, { desc = "Generate RSpec Tests" })
vim.keymap.set("v", "<leader>cb", function() handle_visual_command("CopilotChatRubocop") end, { desc = "Fix Rubocop Issues" })
