-- Protected call to require lualine (in case it's not installed yet)
local lualine_ok, lualine = pcall(require, 'lualine')
if not lualine_ok then
  -- Try to set colorscheme, but don't crash if it's not available
  pcall(vim.cmd, "colorscheme rose-pine-moon")
  return
end

-- Lualine configuration
-- Define the rose-pine theme for lualine
local colors = {
  base = '#232136',
  overlay = '#393552',
  muted = '#6e6a86',
  subtle = '#908caa',
  text = '#e0def4',
  love = '#eb6f92',
  gold = '#f6c177',
  rose = '#ea9a97',
  pine = '#3e8fb0',
  foam = '#9ccfd8',
  iris = '#c4a7e7',
  highlight_low = '#2a273f',
  highlight_med = '#44415a',
  highlight_high = '#56526e',
}

local rose_pine_moon = {
  normal = {
    a = {bg = colors.pine, fg = colors.base, gui = 'bold'},
    b = {bg = colors.highlight_low, fg = colors.text},
    c = {bg = colors.base, fg = colors.subtle}
  },
  insert = {
    a = {bg = colors.foam, fg = colors.base, gui = 'bold'},
    b = {bg = colors.highlight_low, fg = colors.text},
    c = {bg = colors.base, fg = colors.subtle}
  },
  visual = {
    a = {bg = colors.iris, fg = colors.base, gui = 'bold'},
    b = {bg = colors.highlight_low, fg = colors.text},
    c = {bg = colors.base, fg = colors.subtle}
  },
  replace = {
    a = {bg = colors.love, fg = colors.base, gui = 'bold'},
    b = {bg = colors.highlight_low, fg = colors.text},
    c = {bg = colors.base, fg = colors.subtle}
  },
  command = {
    a = {bg = colors.gold, fg = colors.base, gui = 'bold'},
    b = {bg = colors.highlight_low, fg = colors.text},
    c = {bg = colors.base, fg = colors.subtle}
  },
  inactive = {
    a = {bg = colors.base, fg = colors.muted, gui = 'bold'},
    b = {bg = colors.base, fg = colors.muted},
    c = {bg = colors.base, fg = colors.muted}
  }
}

-- Claude Code: read session data from temp file written by ~/.claude/statusline.sh
local function read_claude_data()
  local f = io.open('/tmp/claude_context.json', 'r')
  if not f then return nil end
  local content = f:read('*a')
  f:close()
  if content == '' then return nil end
  local ok, data = pcall(vim.json.decode, content)
  return (ok and data) or nil
end

local function claude_context()
  local data = read_claude_data()
  if not data then return '' end
  local pct = math.floor((data.context_window and data.context_window.used_percentage) or 0)
  local filled = math.floor(pct * 10 / 100)
  local bar = string.rep('▓', filled) .. string.rep('░', 10 - filled)
  return bar .. ' ' .. pct .. '%'
end

local function claude_context_color()
  local data = read_claude_data()
  if not data then return {fg = colors.muted} end
  local pct = math.floor((data.context_window and data.context_window.used_percentage) or 0)
  if pct >= 90 then return {fg = colors.love}
  elseif pct >= 70 then return {fg = colors.gold}
  else return {fg = colors.foam} end
end

local function claude_cost()
  local data = read_claude_data()
  if not data then return '' end
  local cost = (data.cost and data.cost.total_cost_usd) or 0
  if cost == 0 then return '' end
  return string.format('$%.2f', cost)
end

local function claude_duration()
  local data = read_claude_data()
  if not data then return '' end
  local ms = (data.cost and data.cost.total_duration_ms) or 0
  if ms == 0 then return '' end
  local secs = math.floor(ms / 1000)
  return string.format('%dm%ds', math.floor(secs / 60), secs % 60)
end

-- Configure lualine to use the custom rose-pine theme
lualine.setup {
  options = { theme = rose_pine_moon,
    -- Add other lualine options here
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {
      {claude_context,  color = claude_context_color},
      {claude_cost,     color = {fg = colors.gold}},
      {claude_duration, color = {fg = colors.iris}},
      'encoding', 'fileformat', 'filetype',
    },
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
}

-- Function to setup Tmuxline with rose-pine-moon colors
-- Call the function to setup tmuxline

-- Set the colorscheme (protected call in case it's not installed)
-- pcall(vim.cmd, "colorscheme rose-pine")
-- pcall(vim.cmd, "colorscheme rose-pine-main")
pcall(vim.cmd, "colorscheme rose-pine-moon")
-- pcall(vim.cmd, "colorscheme rose-pine-dawn")

