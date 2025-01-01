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

  -- Go to Type Definition
  -- Navigate to the type definition of the symbol under the cursor.
  buf_set_keymap(bufnr, 'n', 'gy', '<Cmd>lua vim.lsp.buf.type_definition()<CR>', opts)

  -- Show Signature Help
  buf_set_keymap(bufnr, 'n', '<leader>k', '<Cmd>lua vim.lsp.buf.signature_help()<CR>', opts)

  -- Rename Symbol
  -- Rename all references to the symbol under the cursor.
  buf_set_keymap(bufnr, 'n', '<leader>rn', '<Cmd>lua vim.lsp.buf.rename()<CR>', opts)

  -- List all references
  buf_set_keymap(bufnr, 'n', '<leader>gr', '<Cmd>Telescope lsp_references<CR>', opts)

  -- Code Lens refresh
  vim.cmd [[
    augroup LSPCodeLens
      autocmd!
      autocmd BufEnter,CursorHold,InsertLeave <buffer> lua vim.lsp.codelens.refresh()
    augroup END
  ]]
end

-- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()

-- For nvim-cmp
local cmp_nvim_lsp = require('cmp_nvim_lsp')
capabilities = cmp_nvim_lsp.default_capabilities(capabilities)

-- Configure the Ruby LSP
-- {
--  "initializationOptions": {
--    "enabledFeatures": {
--      "codeActions": true,
--      "codeLens": true,
--      "completion": true,
--      "definition": true,
--      "diagnostics": true,
--      "documentHighlights": true,
--      "documentLink": true,
--      "documentSymbols": true,
--      "foldingRanges": true,
--      "formatting": true,
--      "hover": true,
--      "inlayHint": true,
--      "onTypeFormatting": true,
--      "selectionRanges": true,
--      "semanticHighlighting": true,
--      "signatureHelp": true,
--      "typeHierarchy": true,
--      "workspaceSymbol": true
--    },
--    "featuresConfiguration": {
--      "inlayHint": {
--        "implicitHashValue": true,
--        "implicitRescue": true
--      }
--    },
--    "indexing": {
--      "excludedPatterns": ["path/to/excluded/file.rb"],
--      "includedPatterns": ["path/to/included/file.rb"],
--      "excludedGems": ["gem1", "gem2", "etc."],
--      "excludedMagicComments": ["compiled:true"]
--    },
--    "formatter": "auto",
--    "linters": [],
--    "experimentalFeaturesEnabled": false
--  }
lspconfig.ruby_lsp.setup({
  cmd = { "ruby-lsp" },
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    rubyLsp = {
      useBundler = false,
    },
  },
  init_options = {
    formatter = 'rubocop',     -- Options: 'auto', 'rubocop', 'standard', 'syntax_tree', 'none'
    linters = { 'rubocop' },   -- Specify the linters to use
    enabledFeatures = {        -- Enable or disable specific LSP features
      "codeActions",
      "codeLens",
      "diagnostics",
      "documentHighlight",
      "documentLink",
      "documentSymbol",
      "foldingRange",
      "formatting",
      "hover",
      --"inlayHint",
      "onTypeFormatting",
      "semanticHighlighting",
      "selectionRange" ,
    },
  },
})
