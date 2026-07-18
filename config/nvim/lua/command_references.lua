-- Command References
-- Press <leader>cm to open the main reference menu
-- Each category has its own popup with specific commands

local function create_popup_buffer(content, title)
  local buf = vim.api.nvim_create_buf(false, true)
  -- Size to the content, but never taller than the window can show.
  local height = math.min(#content, vim.o.lines - 10)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = 60,
    height = height,
    row = 5,
    col = math.floor((vim.o.columns - 60) / 2),
    style = "minimal",
    border = "rounded",
    title = " " .. title .. " ",
    title_pos = "center",
  })

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)
  vim.api.nvim_buf_set_option(buf, 'filetype', 'text')
  vim.api.nvim_buf_set_keymap(buf, 'n', 'q', ':q<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_current_win(win)
end

local function create_main_menu()
  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = 40,
    height = 20,
    row = 5,
    col = math.floor((vim.o.columns - 40) / 2),
    style = "minimal",
    border = "rounded",
    title = " Command References ",
    title_pos = "center",
  })

  local content = {
    "=== Command References ===",
    "",
    "1. Rails Development",
    "2. LSP Commands",
    "3. Diagnostics",
    "4. File Navigation",
    "5. Tmux Integration",
    "6. General Commands",
    "7. C# / .NET",
    "",
    "Press number to view category",
    "Press 'q' to close",
  }

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)
  vim.api.nvim_buf_set_option(buf, 'filetype', 'text')

  -- Set up key mappings for the menu
  local function set_keymap(key, command)
    vim.api.nvim_buf_set_keymap(buf, 'n', key, command, { noremap = true, silent = true })
  end

  -- Number key mappings
  set_keymap('1', ':lua require("command_references").show_rails_commands()<CR>')
  set_keymap('2', ':lua require("command_references").show_lsp_commands()<CR>')
  set_keymap('3', ':lua require("command_references").show_diagnostics_commands()<CR>')
  set_keymap('4', ':lua require("command_references").show_navigation_commands()<CR>')
  set_keymap('5', ':lua require("command_references").show_tmux_commands()<CR>')
  set_keymap('6', ':lua require("command_references").show_general_commands()<CR>')
  set_keymap('7', ':lua require("command_references").show_csharp_commands()<CR>')
  
  -- Enter key mapping based on cursor position
  set_keymap('<CR>', ':lua require("command_references").handle_enter()<CR>')
  
  set_keymap('q', ':q<CR>')

  vim.api.nvim_set_current_win(win)
end

-- Handle Enter key press based on cursor position
local function handle_enter()
  local line = vim.api.nvim_get_current_line()
  local line_str = vim.trim(line)
  
  if line_str == "1. Rails Development" then
    require("command_references").show_rails_commands()
  elseif line_str == "2. LSP Commands" then
    require("command_references").show_lsp_commands()
  elseif line_str == "3. Diagnostics" then
    require("command_references").show_diagnostics_commands()
  elseif line_str == "4. File Navigation" then
    require("command_references").show_navigation_commands()
  elseif line_str == "5. Tmux Integration" then
    require("command_references").show_tmux_commands()
  elseif line_str == "6. General Commands" then
    require("command_references").show_general_commands()
  elseif line_str == "7. C# / .NET" then
    require("command_references").show_csharp_commands()
  end
end

-- Category-specific command functions
local function show_rails_commands()
  local content = {
    "=== Rails Development Commands ===",
    "",
    "Rails Navigation:",
    "  <leader>rm    - Jump to model",
    "  <leader>rc    - Jump to controller",
    "  <leader>rv    - Jump to view",
    "  <leader>rh    - Jump to helper",
    "  <leader>ra    - Jump to mailer",
    "  <leader>rj    - Jump to job",
    "  <leader>rs    - Jump to spec",
    "  <leader>rg    - Jump to migration",
    "  <leader>rf    - Jump to fixture",
    "  <leader>rl    - Jump to locale",
    "  <leader>rC    - Jump to config",
    "",
    "RSpec Commands:",
    "  <leader>t     - Run current spec file",
    "  <leader>s     - Run nearest spec",
    "  <leader>l     - Run last spec",
    "  <leader>a     - Run all specs",
    "",
    "RuboCop:",
    "  <leader>ru    - Run RuboCop on current file",
    "",
    "Press 'q' to close",
  }
  create_popup_buffer(content, "Rails Commands")
end

local function show_lsp_commands()
  local content = {
    "=== LSP Commands ===",
    "",
    "Code Actions:",
    "  <leader>f     - Format code",
    "  <leader>cl    - Refresh Code Lens",
    "  <leader>rcl   - Run Code Lens",
    "  <leader>rn    - Rename symbol",
    "  <leader>lc    - Show code actions",
    "  <leader>la    - Code actions (visual mode)",
    "",
    "Navigation:",
    "  gd            - Go to definition",
    "  gi            - Go to implementation",
    "  gr            - Show references",
    "  gy            - Go to type definition",
    "",
    "Documentation:",
    "  <leader>ha    - Show hover information",
    "  <leader>lh    - Show hover information",
    "  <leader>k     - Show signature help",
    "  <leader>ds    - Show document symbols",
    "  <leader>ws    - Search workspace symbols",
    "",
    "Selection:",
    "  <leader>se    - Expand/shrink selection",
    "  <leader>sh    - Toggle semantic highlighting",
    "",
    "Press 'q' to close",
  }
  create_popup_buffer(content, "LSP Commands")
end

local function show_diagnostics_commands()
  local content = {
    "=== Diagnostics Commands ===",
    "",
    "Basic Diagnostics:",
    "  <leader>de    - Show diagnostics for current line",
    "  [d            - Go to previous diagnostic",
    "  ]d            - Go to next diagnostic",
    "  <leader>ld    - Show all diagnostics",
    "  <leader>lc    - Show code actions",
    "",
    "Trouble UI:",
    "  <leader>xx    - Toggle trouble window",
    "  <leader>xw    - Show workspace diagnostics",
    "  <leader>xd    - Show document diagnostics",
    "  <leader>xl    - Show location list",
    "  <leader>xq    - Show quickfix list",
    "",
    "Press 'q' to close",
  }
  create_popup_buffer(content, "Diagnostics Commands")
end

local function show_navigation_commands()
  local content = {
    "=== File Navigation Commands ===",
    "",
    "Telescope:",
    "  <leader>ff    - Find files",
    "  <leader>fg    - Live grep",
    "  <leader>fb    - Show buffers",
    "  <leader>fh    - Show help tags",
    "",
    "Press 'q' to close",
  }
  create_popup_buffer(content, "Navigation Commands")
end

local function show_tmux_commands()
  local content = {
    "=== Tmux Integration Commands ===",
    "",
    "Runner Management:",
    "  <leader>or    - Open runner",
    "  <leader>nr    - Open runner (horizontal, 30%)",
    "  <leader>kr    - Kill runner",
    "  <leader>fr    - Focus runner",
    "  <leader>ror   - Reorient/resize runner",
    "  <leader>dr    - Detach runner",
    "  <leader>ar    - Reattach runner",
    "  <leader>cr    - Clear runner",
    "",
    "Attach to Pane:",
    "  <leader>ap    - Attach to pane",
    "  <leader>va    - Attach to pane (VTR default)",
    "",
    "Command Execution:",
    "  <leader>sc    - Send command to runner",
    "  <leader>sl    - Send lines to runner",
    "  <leader>sf    - Send file to runner",
    "  <leader>fc    - Flush command",
    "",
    "Press 'q' to close",
  }
  create_popup_buffer(content, "Tmux Commands")
end

local function show_general_commands()
  local content = {
    "=== General Commands ===",
    "",
    "Configuration:",
    "  <leader>r     - Reload Neovim config",
    "  <leader>R     - Reload config in all windows",
    "",
    "Search:",
    "  <leader>h     - Clear search highlights",
    "",
    "Navigation:",
    "  <leader>e     - Open previously edited file",
    "",
    "Clipboard:",
    "  <leader>y     - Copy to clipboard",
    "  <leader>p     - Paste from clipboard",
    "",
    "Press 'q' to close",
  }
  create_popup_buffer(content, "General Commands")
end

local function show_csharp_commands()
  local content = {
    "=== C# / .NET Commands ===",
    "",
    "These are buffer-local to .cs files and",
    "come from the Roslyn language server.",
    "",
    "Build & Run (via tmux runner):",
    "  <leader>dnr   - dotnet run this project",
    "  <leader>dnt   - dotnet test this project",
    "  <leader>dnb   - dotnet build this project",
    "",
    "Navigation:",
    "  gd            - Go to definition",
    "  gi            - Go to implementation",
    "  gy            - Go to type definition",
    "  gr            - Show references",
    "",
    "Code Actions:",
    "  <leader>lc    - Show code actions",
    "  <leader>la    - Code actions (visual mode)",
    "  <leader>rn    - Rename symbol",
    "  <leader>f     - Format buffer",
    "",
    "Documentation:",
    "  <leader>ha    - Show hover information",
    "  <leader>lh    - Show hover information",
    "  <leader>k     - Show signature help",
    "  <leader>ds    - Show document symbols",
    "  <leader>ws    - Search workspace symbols",
    "",
    "Diagnostics:",
    "  <leader>de    - Diagnostics for current line",
    "  <leader>ld    - Show all diagnostics",
    "  [d            - Go to previous diagnostic",
    "  ]d            - Go to next diagnostic",
    "",
    "Server Commands:",
    "  :Roslyn target - Switch between solutions",
    "  :lsp restart   - Restart the language server",
    "  :lsp stop      - Stop the language server",
    "  :Mason         - Manage/update the server",
    "  :checkhealth vim.lsp - Verify attachment",
    "",
    "Press 'q' to close",
  }
  create_popup_buffer(content, "C# / .NET Commands")
end

-- Create a keybinding to show the main menu
vim.api.nvim_set_keymap('n', '<leader>cm', ':lua require("command_references").create_main_menu()<CR>', { noremap = true, silent = true })

return {
  create_main_menu = create_main_menu,
  show_rails_commands = show_rails_commands,
  show_lsp_commands = show_lsp_commands,
  show_diagnostics_commands = show_diagnostics_commands,
  show_navigation_commands = show_navigation_commands,
  show_tmux_commands = show_tmux_commands,
  show_general_commands = show_general_commands,
  show_csharp_commands = show_csharp_commands,
  handle_enter = handle_enter
}