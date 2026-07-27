-- Shared appearance for the LSP information floats.
--
-- Neovim has no global setting for hover/signature-help window options, so both
-- lua/lsp.lua (Ruby) and lua/csharp.lua (C#) route their keymaps through here
-- rather than each passing their own opts.
--
-- The border comes from vim.o.winborder in init.lua. What this adds is a width
-- cap and a title: Roslyn returns documentation as a few very long lines, and an
-- uncapped float spans the whole editor, which is most of why hover output reads
-- as buffer text rather than as a popup.

local M = {}

local function opts(title)
  return {
    title = title,
    title_pos = 'left',
    max_width = 72,
    max_height = 20,
    wrap = true,
  }
end

-- Press the mapping twice to move the cursor into the float, then `q` to close.
function M.hover()
  vim.lsp.buf.hover(opts(' Hover '))
end

function M.signature_help()
  vim.lsp.buf.signature_help(opts(' Signature '))
end

return M
