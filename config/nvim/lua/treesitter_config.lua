-- nvim-treesitter (main branch rewrite).
--
-- The old `require('nvim-treesitter.configs').setup{...}` API is gone. This
-- branch only installs parsers and queries; highlighting, folding and indent
-- are Neovim features you enable yourself per filetype.
local ok, ts = pcall(require, 'nvim-treesitter')
if not ok then
  return
end

-- install_dir is prepended to runtimepath, so these parsers take priority over
-- any left behind elsewhere. A stale parser paired with current queries fails
-- with "Impossible pattern" and silently disables highlighting.
ts.setup({
  install_dir = vim.fn.stdpath('data') .. '/site',
})

-- Parsers and their queries install into stdpath('data')/site by default.
-- Run :TSUpdate after upgrading the plugin -- parser versions are pinned to it.
local parsers = {
  'ruby',
  'c_sharp',
  'embedded_template', -- eruby
  'javascript',
  'sql',
  'yaml',
  'json',
  'http',              -- kulala
  'graphql',
}

-- Asynchronous, and a no-op when everything is already present.
ts.install(parsers)

-- Filetypes, not parser names: ft=cs uses the c_sharp parser, ft=eruby uses
-- embedded_template.
--
-- Ruby is deliberately absent -- treesitter highlighting was disabled for it in
-- the previous config, so the regex syntax stays in charge.
local highlight_filetypes = {
  'cs',
  'eruby',
  'javascript',
  'sql',
  'yaml',
  'json',
  'http',
  'graphql',
}

vim.api.nvim_create_autocmd('FileType', {
  pattern = highlight_filetypes,
  group = vim.api.nvim_create_augroup('treesitter-highlight', { clear = true }),
  callback = function()
    -- Fails harmlessly if the parser has not finished installing yet.
    pcall(vim.treesitter.start)
  end,
})

-- Treesitter folding, window-local so buffers without a parser keep their own
-- foldmethod. Ruby is included: folding works without highlighting.
local fold_filetypes = vim.list_extend({ 'ruby' }, highlight_filetypes)

vim.api.nvim_create_autocmd('FileType', {
  pattern = fold_filetypes,
  group = vim.api.nvim_create_augroup('treesitter-fold', { clear = true }),
  callback = function()
    vim.wo[0][0].foldmethod = 'expr'
    vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
  end,
})

-- Indentation is experimental on this branch and was disabled before, so it
-- stays off:
--   vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
