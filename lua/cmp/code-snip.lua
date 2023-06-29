local config_path = vim.fn.stdpath("config")

require("luasnip.loaders.from_vscode").lazy_load()
-- 自定义片段
require("luasnip.loaders.from_vscode").lazy_load({
  paths = config_path .. "/lua/cmp/snippets",
})
