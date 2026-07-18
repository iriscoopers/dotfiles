-- Ruby indent/textwidth is already handled by the FileType autocmd in
-- lua/rails_config.lua, so this file only adds the Rails project gate.
if require('util.project').is_rails() then
  vim.b.is_rails = true
  -- Rails-only buffer-local keymaps can go here; they stay scoped to this buffer.
end
