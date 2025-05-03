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

-- Set up Rails-specific keymaps
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "ruby", "eruby", "haml", "slim" },
  callback = function()
    -- Rails-specific keymaps
    local opts = { noremap = true, silent = true }
    local keymap = vim.api.nvim_buf_set_keymap

    -- Rails.vim keymaps
    keymap(0, "n", "<leader>rar", ":R<CR>", opts)  -- Run Rails command
    keymap(0, "n", "<leader>ram", ":Rmodel<CR>", opts)  -- Jump to model
    keymap(0, "n", "<leader>rac", ":Rcontroller<CR>", opts)  -- Jump to controller
    keymap(0, "n", "<leader>rav", ":Rview<CR>", opts)  -- Jump to view
    keymap(0, "n", "<leader>rah", ":Rhelper<CR>", opts)  -- Jump to helper
    keymap(0, "n", "<leader>raj", ":Rjavascript<CR>", opts)  -- Jump to JavaScript
    keymap(0, "n", "<leader>ras", ":Rstylesheet<CR>", opts)  -- Jump to stylesheet
    keymap(0, "n", "<leader>rat", ":Rtest<CR>", opts)  -- Jump to test
    keymap(0, "n", "<leader>ral", ":Rlayout<CR>", opts)  -- Jump to layout
    keymap(0, "n", "<leader>rai", ":Rinitializer<CR>", opts)  -- Jump to initializer
    keymap(0, "n", "<leader>rag", ":Rgenerate<CR>", opts)  -- Generate Rails code
    keymap(0, "n", "<leader>rad", ":Rdestroy<CR>", opts)  -- Destroy Rails code
    keymap(0, "n", "<leader>rap", ":Rpreview<CR>", opts)  -- Preview Rails code
    keymap(0, "n", "<leader>rax", ":Rrunner<CR>", opts)  -- Run Rails runner
    keymap(0, "n", "<leader>rak", ":Rrake<CR>", opts)  -- Run Rake task
    keymap(0, "n", "<leader>ra?", ":Rails<CR>", opts)  -- Show Rails.vim help

    -- RSpec keymaps
    keymap(0, "n", "<leader>t", ":call RunCurrentSpecFile()<CR>", opts)
    keymap(0, "n", "<leader>s", ":call RunNearestSpec()<CR>", opts)
    keymap(0, "n", "<leader>l", ":call RunLastSpec()<CR>", opts)
    keymap(0, "n", "<leader>a", ":call RunAllSpecs()<CR>", opts)
  end,
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