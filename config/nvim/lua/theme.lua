local lualine = require('lualine')

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

-- Configure lualine to use the custom rose-pine theme
lualine.setup {
  options = { theme = rose_pine_moon,
    -- Add other lualine options here
  },
  -- Add other lualine configurations here
}

-- Function to setup Tmuxline with rose-pine-moon colors
-- Call the function to setup tmuxline

-- Set the colorscheme
-- vim.cmd("colorscheme rose-pine")
-- vim.cmd("colorscheme rose-pine-main")
vim.cmd("colorscheme rose-pine-moon")
-- vim.cmd("colorscheme rose-pine-dawn")

