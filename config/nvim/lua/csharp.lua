-- C# / .NET support via the Roslyn language server.
--
-- Design note: this file never touches Ruby. roslyn.nvim registers itself only
-- for `cs`/`razor` buffers (see its plugin/roslyn.lua), and the keymaps below
-- deliberately skip ruby/eruby buffers so they can't fight the on_attach
-- mappings already defined in lua/lsp.lua.

-- The Roslyn server is a .NET app and needs DOTNET_ROOT to locate the runtime.
-- Homebrew installs the SDK outside the default search path, and a GUI-launched
-- Neovim won't inherit the shell export, so resolve it here as well.
if vim.env.DOTNET_ROOT == nil or vim.env.DOTNET_ROOT == '' then
  local platform = require('util.platform')
  local candidates = platform.is_mac
      and { '/opt/homebrew/opt/dotnet/libexec', '/usr/local/share/dotnet' }
      or { vim.env.HOME .. '/.dotnet', '/usr/share/dotnet', '/usr/lib/dotnet' }

  for _, dir in ipairs(candidates) do
    if (vim.uv or vim.loop).fs_stat(dir) then
      vim.env.DOTNET_ROOT = dir
      break
    end
  end
end

-- Mason installs and manages the Roslyn server binary.
-- The Crashdummyy registry provides a `roslyn` package tracking the version
-- shipped with the VSCode C# extension (mason-registry's own build lags behind).
local mason_ok, mason = pcall(require, 'mason')
if mason_ok then
  mason.setup({
    registries = {
      'github:mason-org/mason-registry',
      'github:Crashdummyy/mason-registry',
    },
  })
end

local roslyn_ok, roslyn = pcall(require, 'roslyn')
if not roslyn_ok then
  return
end

roslyn.setup({
  -- Find the .sln even when projects aren't direct children of it.
  broad_search = true,
  -- Let the server do its own file watching. Neovim's watcher throws
  -- "watch.watch: ENOENT" on the churn in bin/ and obj/.
  filewatching = 'roslyn',
})

-- Give Roslyn the same nvim-cmp completion capabilities the Ruby LSP gets.
local cmp_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if cmp_ok then
  vim.lsp.config('roslyn', {
    capabilities = cmp_nvim_lsp.default_capabilities(),
  })
end

-- Buffer-local LSP keymaps for non-Ruby buffers.
-- These mirror the Ruby mappings in lua/lsp.lua so the same keys work in C#.
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('csharp-lsp-keymaps', { clear = true }),
  callback = function(args)
    local ft = vim.bo[args.buf].filetype
    -- Ruby buffers already get their mappings from lsp.lua's on_attach.
    if ft == 'ruby' or ft == 'eruby' then
      return
    end

    local function map(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = args.buf, silent = true, desc = desc })
    end

    map('n', 'gd', vim.lsp.buf.definition, 'Go to definition')
    map('n', 'gi', vim.lsp.buf.implementation, 'Go to implementation')
    map('n', 'gy', vim.lsp.buf.type_definition, 'Go to type definition')
    map('n', 'gr', '<Cmd>Telescope lsp_references<CR>', 'References')

    -- Titled, width-capped floats shared with the Ruby maps; see util/float.lua.
    local float = require('util.float')
    map('n', '<leader>ha', float.hover, 'Hover')
    map('n', '<leader>lh', float.hover, 'Hover')
    map('n', '<leader>k', float.signature_help, 'Signature help')
    map('n', '<leader>rn', vim.lsp.buf.rename, 'Rename symbol')
    map('n', '<leader>lc', vim.lsp.buf.code_action, 'Code action')
    map('v', '<leader>la', vim.lsp.buf.code_action, 'Code action (range)')
    map('n', '<leader>f', function() vim.lsp.buf.format({ async = true }) end, 'Format buffer')

    map('n', '<leader>ds', '<Cmd>Telescope lsp_document_symbols<CR>', 'Document symbols')
    map('n', '<leader>ws', '<Cmd>Telescope lsp_workspace_symbols<CR>', 'Workspace symbols')

    map('n', '<leader>de', vim.diagnostic.open_float, 'Line diagnostics')
    map('n', '<leader>ld', '<Cmd>Telescope diagnostics<CR>', 'All diagnostics')
    map('n', '[d', function() vim.diagnostic.jump({ count = -1, float = true }) end, 'Previous diagnostic')
    map('n', ']d', function() vim.diagnostic.jump({ count = 1, float = true }) end, 'Next diagnostic')
  end,
})

-- Run the current .NET project from the tmux runner, matching the RSpec workflow.
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'cs',
  callback = function()
    local project = require('util.project')

    -- Namespaced under <leader>dn ("dotNet") to avoid shadowing the vim-tmux-runner
    -- maps enabled by VtrUseVtrMaps (<leader>dr is VtrDetachRunner).
    local function send(cmd)
      return function()
        local root = project.dotnet_root()
        if not root then
          vim.notify('No .sln/.csproj found above this file', vim.log.levels.WARN)
          return
        end
        vim.cmd('VtrSendCommandToRunner ' .. cmd .. ' ' .. vim.fn.fnameescape(root))
      end
    end

    local map = function(lhs, cmd, desc)
      vim.keymap.set('n', lhs, send(cmd), { buffer = true, desc = desc })
    end

    map('<leader>dnr', 'dotnet run --project', 'dotnet run this project')
    map('<leader>dnt', 'dotnet test', 'dotnet test this project')
    map('<leader>dnb', 'dotnet build', 'dotnet build this project')
  end,
})
