-- Protected call to require nvim-treesitter
local config_ok, config = pcall(require, 'nvim-treesitter.configs')
if not config_ok then
  return
end

config.setup({
  ensure_installed = { 'ruby', 'javascript', 'sql', 'yaml', 'json' }, -- or "all"
  highlight = {
    enable = true,
    disable = { 'ruby' }, -- list of language that will be disabled
  },
  fold = { enable = true },
  indent = { enable = false },
  autotag = { enable = false },
  context_commentstring = { enable = false },
  incremental_selection = { enable = false },
  refactor = {
    highlight_definitions = { enable = false },
    highlight_current_scope = { enable = false },
    smart_rename = { enable = false },
    navigation = { enable = false },
  },
  playground = { enable = false },
  rainbow = { enable = false },
  textobjects = { enable = false },
  matchup = { enable = false },
  query_linter = { enable = false },
  rainbow = { enable = false },
  autotag = { enable = false },
  context_commentstring = { enable = false },
  textobjects = { enable = false },
  matchup = { enable = false },
})
