-- Project-type detection, so language tooling only activates where it belongs.
local M = {}
local uv = vim.uv or vim.loop

local function buf_dir()
  local dir = vim.fn.expand('%:p:h')
  if dir == nil or dir == '' then return vim.fn.getcwd() end
  return dir
end

local function find_up(matcher)
  return vim.fs.find(matcher, { upward = true, path = buf_dir() })[1]
end

-- .NET: a solution or project file anywhere up the tree
function M.dotnet_root()
  local hit = find_up(function(name)
    return name:match('%.sln$') or name:match('%.slnx$') or name:match('%.csproj$')
  end)
  return hit and vim.fs.dirname(hit) or nil
end

function M.is_dotnet() return M.dotnet_root() ~= nil end

-- Rails: a Gemfile whose app also has config/application.rb
function M.rails_root()
  local gemfile = find_up({ 'Gemfile' })
  if not gemfile then return nil end
  local root = vim.fs.dirname(gemfile)
  if uv.fs_stat(root .. '/config/application.rb') then return root end
  return nil
end

function M.is_rails() return M.rails_root() ~= nil end

function M.is_ruby()
  return find_up({ 'Gemfile', '.ruby-version' }) ~= nil
end

return M
