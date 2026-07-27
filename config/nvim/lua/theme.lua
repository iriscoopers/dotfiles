-- Rose Pine Moon palette, shared by the lualine theme and the floating-window
-- highlights below.
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

-- Set the colorscheme first: the highlight overrides below have to run after it,
-- or rose-pine clears them.
-- pcall(vim.cmd, "colorscheme rose-pine")
-- pcall(vim.cmd, "colorscheme rose-pine-main")
-- pcall(vim.cmd, "colorscheme rose-pine-dawn")
pcall(vim.cmd, "colorscheme rose-pine-moon")

-- Floating-window surfaces.
--
-- Out of the box a completion popup is nearly invisible: nvim-cmp's bordered()
-- preset maps the popup body to `Normal`, so it paints on the exact same
-- background as the buffer underneath it, and rose-pine's NormalFloat is only
-- one shade off. The result is documentation text that reads as if it were
-- spliced into the file you're editing.
--
-- The fix is contrast plus separation: lift every float onto `overlay`, a
-- visibly raised surface, and give the completion menu and its documentation
-- panel different border colours so it's obvious they're two windows.
local function float_highlights()
  local set = vim.api.nvim_set_hl

  -- Generic floats: LSP hover, signature help, diagnostics.
  set(0, 'NormalFloat', { bg = colors.overlay, fg = colors.text })
  set(0, 'FloatBorder', { bg = colors.overlay, fg = colors.iris })
  set(0, 'FloatTitle',  { bg = colors.overlay, fg = colors.iris, bold = true })

  -- nvim-cmp completion menu: quiet border, it's the window you're driving.
  set(0, 'CmpNormal', { bg = colors.overlay, fg = colors.text })
  set(0, 'CmpBorder', { bg = colors.overlay, fg = colors.muted })
  set(0, 'CmpSel',    { bg = colors.highlight_high, fg = colors.text, bold = true })

  -- Documentation panel: accent border, so the block of prose that lands on top
  -- of the neighbouring split is unmistakably a popup.
  set(0, 'CmpDocNormal', { bg = colors.overlay, fg = colors.text })
  set(0, 'CmpDocBorder', { bg = colors.overlay, fg = colors.foam })

  -- Completion item columns.
  set(0, 'CmpItemAbbrMatch',      { fg = colors.foam, bold = true })
  set(0, 'CmpItemAbbrMatchFuzzy', { fg = colors.foam })
  set(0, 'CmpItemAbbrDeprecated', { fg = colors.muted, strikethrough = true })
  set(0, 'CmpItemKind',           { fg = colors.gold })
  set(0, 'CmpItemMenu',           { fg = colors.muted, italic = true })

  -- Scrollbar. cmp draws it as a child window sitting on the right border
  -- column, so an invisible track reads as a hole punched in the border. Give
  -- the track its own shade and the thumb the accent colour, and the overlap
  -- looks like a scrollbar instead of a rendering glitch.
  set(0, 'PmenuSbar',  { bg = colors.highlight_med })
  set(0, 'PmenuThumb', { bg = colors.iris })
end

float_highlights()

-- Re-apply after any :colorscheme, which resets highlight groups.
vim.api.nvim_create_autocmd('ColorScheme', {
  group = vim.api.nvim_create_augroup('float-highlights', { clear = true }),
  callback = float_highlights,
})

-- Protected call to require lualine (in case it's not installed yet)
local lualine_ok, lualine = pcall(require, 'lualine')
if not lualine_ok then
  return
end

-- Lualine configuration
-- Define the rose-pine theme for lualine
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

