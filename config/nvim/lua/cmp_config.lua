-- Protected calls to require cmp and luasnip
local cmp_ok, cmp = pcall(require, 'cmp')
local luasnip_ok, luasnip = pcall(require, 'luasnip')

if not cmp_ok or not luasnip_ok then
  return
end

local lsp_types = require('cmp.types').lsp

-- Icons for the kind column, so a Class and an Enum are distinguishable at a
-- glance instead of only by the word next to them. Requires a Nerd Font, which
-- the diagnostic signs in init.lua already assume.
local kind_icons = {
  Text = '󰉿', Method = '󰆧', Function = '󰊕', Constructor = '',
  Field = '󰜢', Variable = '󰀫', Class = '󰠱', Interface = '',
  Module = '', Property = '󰜢', Unit = '󰑭', Value = '󰎠',
  Enum = '', Keyword = '󰌋', Snippet = '', Color = '󰏘',
  File = '󰈙', Reference = '󰈇', Folder = '󰉋', EnumMember = '',
  Constant = '󰏿', Struct = '󰙅', Event = '', Operator = '󰆕',
  TypeParameter = '',
}

local source_labels = {
  nvim_lsp = 'LSP',
  luasnip = 'Snippet',
  buffer = 'Buffer',
  path = 'Path',
}

-- Roslyn's XML docs are long. Cap the panel so it stays a readable column
-- instead of stretching across whatever split it happens to cover.
local DOC_MAX_WIDTH = 72
local DOC_MAX_HEIGHT = 20

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
  -- Spelled out rather than using cmp.config.window.bordered(): that helper
  -- maps the popup body to `Normal`, i.e. the same background as the buffer
  -- behind it, and derives its border from vim.o.winborder (so it silently
  -- produced border = 'none'). The highlight groups come from lua/theme.lua.
  window = {
    completion = {
      border = 'rounded',
      winhighlight = 'Normal:CmpNormal,FloatBorder:CmpBorder,CursorLine:CmpSel,Search:None',
      scrollbar = true,
      side_padding = 1,
    },
    documentation = {
      border = 'rounded',
      winhighlight = 'Normal:CmpDocNormal,FloatBorder:CmpDocBorder,Search:None',
      max_width = DOC_MAX_WIDTH,
      max_height = DOC_MAX_HEIGHT,
    },
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
    fields = { 'abbr', 'kind', 'menu' },
    -- cmp glues a bare '~' onto items that do more than insert their label, and
    -- nothing on screen says what it means. Turned off here and replaced by the
    -- words below, which are worked out from the same fields cmp reads (see
    -- cmp/entry.lua, "~ indicator") at the same point in the render -- so the
    -- hint still shows up exactly when '~' used to, just legibly.
    expandable_indicator = false,
    format = function(entry, vim_item)
      local icon = kind_icons[vim_item.kind]
      if icon then
        vim_item.kind = icon .. ' ' .. vim_item.kind
      end

      -- Very long generic signatures otherwise push the kind and menu columns
      -- off the right edge of the popup.
      if vim.fn.strchars(vim_item.abbr) > 40 then
        vim_item.abbr = vim.fn.strcharpart(vim_item.abbr, 0, 39) .. '…'
      end

      -- cmp has already put the server's labelDetails in the menu column. For
      -- Roslyn that's the namespace a type comes from, which is exactly what
      -- tells System.Collections.Generic.List apart from
      -- System.Collections.Specialized.ListDictionary -- so keep it, and fall
      -- back to naming the source only when there's nothing better to show.
      local menu = vim_item.menu
      if menu == nil or menu == '' then
        menu = '[' .. (source_labels[entry.source.name] or entry.source.name) .. ']'
      end

      local item = entry.completion_item
      if #(item.additionalTextEdits or {}) > 0 then
        -- Accepting this also writes an import at the top of the file: a `using`
        -- in C#, a `require` in Ruby.
        menu = menu .. ' +import'
      elseif item.kind == lsp_types.CompletionItemKind.Snippet
          or (item.insertTextFormat == lsp_types.InsertTextFormat.Snippet
              and entry:get_insert_text() ~= entry:get_word()) then
        -- Expands to more than its label, and drops you on a placeholder.
        menu = menu .. ' +snippet'
      end

      vim_item.menu = menu
      return vim_item
    end
  },
})

-- Stop the documentation panel from clipping the end of a sentence.
--
-- cmp sizes that window with hard-wrap arithmetic -- ceil(line_width /
-- window_width), via vim.lsp.util._make_floating_popup_size -- but renders it
-- with 'linebreak', which breaks at word boundaries and therefore needs more
-- rows than the arithmetic predicts. A single-paragraph C# summary is one
-- buffer line a couple of hundred columns wide, so it reliably comes up a row
-- short and the tail disappears behind an '@@@' marker.
--
-- nvim_win_text_height measures the wrapped height for real. Re-measure once
-- the window is up and grow it to fit. Guarded throughout: if a future cmp
-- moves this internal, the popup just goes back to its old size.
local docs_view_ok, docs_view = pcall(require, 'cmp.view.docs_view')
if docs_view_ok then
  local open = docs_view.open

  docs_view.open = function(self, entry, view, bottom_up)
    open(self, entry, view, bottom_up)

    local win = self.window and self.window.win
    if not win or not vim.api.nvim_win_is_valid(win) then
      return
    end

    local measured, text_height = pcall(vim.api.nvim_win_text_height, win, {})
    if not measured then
      return
    end

    local style = self.window.style
    local wanted = math.min(text_height.all, DOC_MAX_HEIGHT)
    if wanted <= style.height then
      return
    end

    -- Reopening through cmp's own window API rather than nvim_win_set_config:
    -- it keeps cmp's cached style in sync, clamps the window to the bottom of
    -- the screen for us, and re-runs the scrollbar check -- which now finds the
    -- content fits and takes the scrollbar back off the border.
    local resized = vim.tbl_extend('force', style, { height = wanted })
    if bottom_up then
      -- Flipped above the cursor: hold the bottom edge and grow upwards.
      resized.row = math.max(style.row - (wanted - style.height), 0)
    end
    pcall(function()
      self.window:open(resized)
    end)
  end
end

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
