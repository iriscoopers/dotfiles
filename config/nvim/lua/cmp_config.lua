-- Protected calls to require cmp and luasnip
local cmp_ok, cmp = pcall(require, 'cmp')
local luasnip_ok, luasnip = pcall(require, 'luasnip')

if not cmp_ok or not luasnip_ok then
  return
end

-- Super-Tab like mapping
local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup({
  snippet = {
    expand = function(args)
      -- For LuaSnip users.
      require('luasnip').lsp_expand(args.body)
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept selected item.
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp', priority = 1000 },  -- LSP source with high priority
    { name = 'luasnip', priority = 750 },    -- Snippets source
    { name = 'buffer', priority = 500 },     -- Buffer source with lower priority
    { name = 'path', priority = 250 },       -- Path source
  }),
  formatting = {
    format = function(entry, vim_item)
      -- Add source name
      vim_item.menu = ({
        nvim_lsp = "[LSP]",
        luasnip = "[Snippet]",
        buffer = "[Buffer]",
        path = "[Path]"
      })[entry.source.name]
      return vim_item
    end
  },
})

-- Set configuration for specific filetype.
cmp.setup.filetype('ruby', {
  sources = cmp.config.sources({
    { name = 'nvim_lsp', priority = 1000 },
    { name = 'luasnip', priority = 750 },
    { name = 'buffer', priority = 500 },
    { name = 'path', priority = 250 },
  })
})

-- Use buffer source for `/`.
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':'.
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

-- Add Ruby and Rails snippet completions
luasnip.add_snippets("ruby", {
  luasnip.snippet("def", {
    luasnip.text_node("def "),
    luasnip.insert_node(1, "method_name"),
    luasnip.text_node({"", "  "}),
    luasnip.insert_node(0),
    luasnip.text_node({"", "end"}),
  }),
  luasnip.snippet("do", {
    luasnip.text_node("do"),
    luasnip.text_node({"", "  "}),
    luasnip.insert_node(0),
    luasnip.text_node({"", "end"}),
  }),
  luasnip.snippet("cl", {
    luasnip.text_node("class "),
    luasnip.insert_node(1, "ClassName"),
    luasnip.text_node({"", "  "}),
    luasnip.insert_node(0),
    luasnip.text_node({"", "end"}),
  }),
})

-- Set up Rails-specific snippets
luasnip.filetype_extend("eruby", {"html", "ruby"})
luasnip.filetype_extend("slim", {"html", "ruby"})
