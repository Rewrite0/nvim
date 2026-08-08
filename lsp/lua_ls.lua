return {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = { ".luarc.json", ".luarc.jsonc", ".stylua.toml", "stylua.toml", ".git" },
  settings = {
    Lua = {
      completion = { callSnippet = "Replace" },
      diagnostics = { globals = { "vim", "Snacks" } },
      hint = { enable = true },
      workspace = { checkThirdParty = false },
    },
  },
}
