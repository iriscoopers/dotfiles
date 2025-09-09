-- Rails-specific configurations

-- Set filetype for Rails files
vim.filetype.add({
  extension = {
    rb = "ruby",
    rake = "ruby",
    gemspec = "ruby",
    erb = "eruby",
    haml = "haml",
    slim = "slim",
    jbuilder = "ruby",
  },
  pattern = {
    [".*%.rb$"] = "ruby",
    [".*%.rake$"] = "ruby",
    [".*%.gemspec$"] = "ruby",
    [".*%.erb$"] = "eruby",
    [".*%.haml$"] = "haml",
    [".*%.slim$"] = "slim",
    [".*%.jbuilder$"] = "ruby",
    ["Gemfile"] = "ruby",
    ["Rakefile"] = "ruby",
    ["config.ru"] = "ruby",
    ["Guardfile"] = "ruby",
    ["Podfile"] = "ruby",
    ["*.podspec"] = "ruby",
  },
})

-- Set up Rails-specific settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "ruby", "eruby", "haml", "slim" },
  callback = function()
    -- Set indentation
    vim.opt_local.expandtab = true
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.smartindent = true

    -- Set text width for Ruby files
    vim.opt_local.textwidth = 100

    -- Enable spell checking for comments
    vim.opt_local.spell = true
    vim.opt_local.spelllang = "en"

    -- Include Rails directories in path
    vim.opt_local.path:append("app/**,lib/**,spec/**,config/**,db/**,script/**,elasticsearch/**")

    -- Add suffixes to jump to files
    vim.opt_local.suffixesadd:append(".rb")
    vim.opt_local.includeexpr = [[substitute(substitute(substitute(v:fname,'::','/','g'),'$','.rb',''),'(\<\u\l\+\|\l\+)(\u)','\l\1_\l\2','g')]]
  end,
})

-- Rails navigation commands
local function create_rails_command(name, path)
  vim.api.nvim_create_user_command(name, function()
    local ok = pcall(vim.cmd, 'normal gf')
    if not ok then
      vim.cmd('find ' .. path)
    end
  end, {})
end

-- Create all the Rails navigation commands
create_rails_command('Emodel', 'app/models')
create_rails_command('Econtroller', 'app/controllers')
create_rails_command('Eview', 'app/views')
create_rails_command('Ehelper', 'app/helpers')
create_rails_command('Emailer', 'app/mailers')
create_rails_command('Ejob', 'app/jobs')
create_rails_command('Espec', 'spec')
create_rails_command('Econfig', 'config')
create_rails_command('Emigration', 'db/migrate')
create_rails_command('Efixture', 'test/fixtures')
create_rails_command('Elocale', 'config/locales')

-- Rails keymaps for navigation
vim.keymap.set('n', '<leader>rm', ':Emodel<CR>', { desc = 'Jump to model' })
vim.keymap.set('n', '<leader>rc', ':Econtroller<CR>', { desc = 'Jump to controller' })
vim.keymap.set('n', '<leader>rv', ':Eview<CR>', { desc = 'Jump to view' })
vim.keymap.set('n', '<leader>rh', ':Ehelper<CR>', { desc = 'Jump to helper' })
vim.keymap.set('n', '<leader>ra', ':Emailer<CR>', { desc = 'Jump to mailer' })
vim.keymap.set('n', '<leader>rj', ':Ejob<CR>', { desc = 'Jump to job' })
vim.keymap.set('n', '<leader>rs', ':Espec<CR>', { desc = 'Jump to spec' })
vim.keymap.set('n', '<leader>rg', ':Emigration<CR>', { desc = 'Jump to migration' })
vim.keymap.set('n', '<leader>rf', ':Efixture<CR>', { desc = 'Jump to fixture' })
vim.keymap.set('n', '<leader>rl', ':Elocale<CR>', { desc = 'Jump to locale' })
vim.keymap.set('n', '<leader>rC', ':Econfig<CR>', { desc = 'Jump to config' })

-- Debug Rails setup on startup
vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    vim.notify('Rails command available: ' .. tostring(vim.fn.exists(':Rails')))
    vim.notify('Current directory: ' .. vim.fn.getcwd())
    -- Try to load rails plugin explicitly
    vim.cmd('runtime! plugin/rails.vim')
  end
})

-- Set up Rails-specific completion
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "ruby", "eruby", "haml", "slim" },
  callback = function()
    -- Enable Rails-specific completion
    vim.opt_local.completefunc = "v:lua.vim.lsp.omnifunc"
    vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"
  end,
})

-- Set up Rails-specific formatting
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.rb", "*.rake", "Gemfile", "*.jbuilder", "*.haml", "*.erb" },
  callback = function()
    -- Run Rubocop auto-correct on save
    vim.cmd("silent! !rubocop -a <afile>")
  end,
})
