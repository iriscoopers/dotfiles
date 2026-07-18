-- OS detection helper, used for anything platform-specific.
local M = {}
local sysname = (vim.uv or vim.loop).os_uname().sysname

M.is_mac     = sysname == 'Darwin'
M.is_windows = sysname:find('Windows') ~= nil
M.is_wsl     = vim.fn.has('wsl') == 1
M.is_linux   = not M.is_mac and not M.is_windows

function M.name()
  if M.is_mac then return 'mac'
  elseif M.is_windows then return 'windows'
  else return 'linux' end
end

return M
