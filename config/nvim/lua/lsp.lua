-- Setup nvim-lspconfig
local lspconfig = require('lspconfig')

-- Function to attach completion and diagnostics when LSP is ready
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <C-x><C-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Folding Ranges
  -- Use LSP-provided folding ranges for code folding.
  -- Neovim already has default keys for folding:
  --   za: Toggle fold under the cursor.
  --   zc: Close fold.
  --   zo: Open fold.
  --   zM: Close all folds.
  --   zR: Open all folds.
  -- vim.api.nvim_buf_set_option(bufnr, 'foldmethod', 'expr')
  -- vim.api.nvim_buf_set_option(bufnr, 'foldexpr', 'vim.lsp.buf.foldexpr()')

  local opts = { noremap=true, silent=true }
  local buf_set_keymap = vim.api.nvim_buf_set_keymap

  -- Mappings for Ruby LSP
  -- Formatting
  -- Format your code according to the formatter specified in your init_options
  buf_set_keymap(bufnr, 'n', '<leader>f', '<Cmd>lua vim.lsp.buf.format { async = true }<CR>', opts)

  -- Code Lens
  -- Provides contextual information (e.g., references count) displayed inline in your code.
  buf_set_keymap(bufnr, 'n', '<leader>cl', '<Cmd>lua vim.lsp.codelens.refresh()<CR>', opts)
  buf_set_keymap(bufnr, 'n', '<leader>rcl', '<Cmd>lua vim.lsp.codelens.run()<CR>', opts)

  -- Document Symbols
  -- Navigate to symbols (functions, classes, etc.) within the current document.
  -- Opens a list of symbols in the current document.
  -- buf_set_keymap(bufnr, 'n', '<leader>ds', '<Cmd>lua vim.lsp.buf.document_symbol()<CR>', opts)
  buf_set_keymap(bufnr, 'n', '<leader>ds', '<Cmd>Telescope lsp_document_symbols<CR>', opts)

  -- Workspace Symbols
  -- Opens a search prompt for workspace symbols.
  -- buf_set_keymap(bufnr, 'n', '<leader>ws', '<Cmd>lua vim.lsp.buf.workspace_symbol()<CR>', opts)
  buf_set_keymap(bufnr, 'n', '<leader>ws', '<Cmd>Telescope lsp_workspace_symbols<CR>', opts)

  -- Inlay Hints (Neovim 0.10+)
  -- Display inline hints in your code, such as parameter names or type information.
  -- Toggles inlay hints on or off for the current buffer.
  -- buf_set_keymap(bufnr, 'n', '<leader>ih', '<Cmd>lua vim.lsp.inlay_hint(bufnr, nil)<CR>', opts)

  -- Selection Range
  -- Expand or shrink the selection based on the syntax tree.
  buf_set_keymap(bufnr, 'n', '<leader>se', '<Cmd>lua vim.lsp.buf.selection_range()<CR>', opts)

  -- Semantic Tokens Toggle
  -- Provides semantic token information to enhance syntax highlighting.
  -- Semantic highlighting is enabled by default in Neovim when the LSP server supports it.
  -- Ensure your colorscheme supports LSP semantic tokens.
  buf_set_keymap(bufnr, 'n', '<leader>sh', '<Cmd>lua vim.lsp.semantic_tokens.toggle()<CR>', opts)

  -- Hover Actions
  -- Shows hover information for the symbol under the cursor.
  buf_set_keymap(bufnr, 'n', '<leader>ha', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap(bufnr, 'n', '<Leader>lh', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)

  -- Go to Type Definition
  -- Navigate to the type definition of the symbol under the cursor.
  buf_set_keymap(bufnr, 'n', 'gy', '<Cmd>lua vim.lsp.buf.type_definition()<CR>', opts)

  -- Show Signature Help
  buf_set_keymap(bufnr, 'n', '<leader>k', '<Cmd>lua vim.lsp.buf.signature_help()<CR>', opts)

  -- Rename Symbol
  -- Rename all references to the symbol under the cursor.
  buf_set_keymap(bufnr, 'n', '<leader>rn', '<Cmd>lua vim.lsp.buf.rename()<CR>', opts)

  -- Go to definition
  buf_set_keymap(bufnr, 'n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)

  -- Go to implementation
  buf_set_keymap(bufnr, 'n', 'gi', '<Cmd>lua vim.lsp.buf.implementation()<CR>', opts)

  -- Go to references
  buf_set_keymap(bufnr, 'n', 'gr', '<Cmd>Telescope lsp_references<CR>', opts)

  -- Show diagnostics for current line
  buf_set_keymap(bufnr, 'n', '<leader>de', '<Cmd>lua vim.diagnostic.open_float()<CR>', opts)

  -- Navigate diagnostics
  buf_set_keymap(bufnr, 'n', '[d', '<Cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap(bufnr, 'n', ']d', '<Cmd>lua vim.diagnostic.goto_next()<CR>', opts)

  -- Show all diagnostics
  buf_set_keymap(bufnr, 'n', '<leader>ld', '<Cmd>Telescope diagnostics<CR>', opts)

  -- Code actions
  buf_set_keymap(bufnr, 'n', '<leader>lc', '<Cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap(bufnr, 'v', '<leader>la', '<Cmd>lua vim.lsp.buf.range_code_action()<CR>', opts)

  -- Code Lens refresh
  vim.cmd [[
    augroup LSPCodeLens
      autocmd!
      autocmd BufEnter,CursorHold,InsertLeave <buffer> lua vim.lsp.codelens.refresh()
    augroup END
  ]]

  -- Rubocop autocommands
  vim.cmd [[
    augroup Rubocop
      autocmd!
      autocmd BufWritePost *.rb,*.rake,Gemfile,*.jbuilder,*.haml,*.erb silent! !rubocop -a <afile>
    augroup END
  ]]
end

-- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()

-- For nvim-cmp
local cmp_nvim_lsp = require('cmp_nvim_lsp')
capabilities = cmp_nvim_lsp.default_capabilities(capabilities)

-- Configure the Ruby LSP with Rubocop integration
-- Enable debug logging for LSP
vim.lsp.set_log_level("debug")

-- Add error handler for ruby-lsp
local ruby_lsp_error_handler = function(err, result, ctx, config)
  if err then
    vim.notify(string.format('Error in ruby-lsp: %s', vim.inspect(err)), vim.log.levels.ERROR)
  end
  vim.lsp.handlers["window/showMessage"](err, result, ctx, config)
end

lspconfig.ruby_lsp.setup({
  before_init = function(initialize_params)
    initialize_params.initializationOptions = {
      enabledFeatures = { "hover", "documentSymbol", "documentLink", "diagnostics" }
    }
  end,
  cmd = { 'ruby-lsp' },  -- The executable will handle the composed bundle setup
  on_attach = function(client, bufnr)
    vim.notify('LSP attached to buffer ' .. bufnr)
    on_attach(client, bufnr)
  end,
  on_exit = function(code, signal, client_id)
    vim.notify(string.format('ruby-lsp exited with code %d and signal %d', code, signal))
  end,
  handlers = {
    ["window/showMessage"] = ruby_lsp_error_handler,
  },
  capabilities = capabilities,
  flags = {
    debounce_text_changes = 150,
  },
  init_options = {
    formatter = 'rubocop',     -- Use Rubocop for formatting
    linters = { 'rubocop' },   -- Use Rubocop for linting
    enabledFeatures = {        -- Enable all useful LSP features
      "codeActions",
      "codeLens",
      "diagnostics",
      "documentHighlight",
      "documentLink",
      "documentSymbol",
      "foldingRange",
      "formatting",
      "hover",
      "inlayHint",
      "onTypeFormatting",
      "semanticHighlighting",
      "selectionRange"
    }
  },
  settings = {
    rubyLsp = {
      -- The composed bundle strategy will set up a separate bundle under .ruby-lsp
      -- in your project directory that includes ruby-lsp and your project's gems
      useBundler = false,  -- Set to false to use composed bundle strategy
    },
  },
})

-- Setup diagnostics display
vim.diagnostic.config({
  virtual_text = {
    prefix = '●', -- Use a symbol for diagnostic hints
    source = 'if_many',
  },
  float = {
    source = 'always',
    border = 'rounded',
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

-- Setup diagnostic signs
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- Setup trouble.nvim for better diagnostics UI
require("trouble").setup {
  position = "bottom",
  height = 10,
  icons = true,
  mode = "workspace_diagnostics",
  fold_open = "",
  fold_closed = "",
  group = true,
  padding = true,
  action_keys = {
    close = "q",
    cancel = "<esc>",
    refresh = "r",
    jump = {"<cr>", "<tab>"},
    open_split = { "<c-x>" },
    open_vsplit = { "<c-v>" },
    open_tab = { "<c-t>" },
    jump_close = {"o"},
    toggle_mode = "m",
    toggle_preview = "P",
    hover = "K",
    preview = "p",
    close_folds = {"zM", "zm"},
    open_folds = {"zR", "zr"},
    toggle_fold = {"zA", "za"},
    previous = "k",
    next = "j"
  },
}

-- Key mappings for trouble.nvim
vim.keymap.set("n", "<leader>xx", "<cmd>TroubleToggle<cr>", {silent = true, noremap = true})
vim.keymap.set("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", {silent = true, noremap = true})
vim.keymap.set("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>", {silent = true, noremap = true})
vim.keymap.set("n", "<leader>xl", "<cmd>TroubleToggle loclist<cr>", {silent = true, noremap = true})
vim.keymap.set("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>", {silent = true, noremap = true})
