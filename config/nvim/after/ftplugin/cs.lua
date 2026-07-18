-- C# editor settings. Buffer-local, so they never leak into Ruby buffers.
vim.bo.shiftwidth = 4
vim.bo.tabstop = 4
vim.bo.softtabstop = 4
vim.bo.expandtab = true

-- The global textwidth/colorcolumn of 100 is tuned for Ruby; C# runs wider.
vim.bo.textwidth = 120
vim.wo.colorcolumn = '120'
