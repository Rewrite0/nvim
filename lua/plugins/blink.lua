return {
  {
    "saghen/blink.cmp",
    version = "1.*",
    event = "InsertEnter",
    dependencies = {
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
    },
    opts = {
      keymap = { preset = "default" },
      appearance = { nerd_font_variant = "mono" },
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 300 },
        list = { selection = { preselect = false, auto_insert = true } },
      },
      signature = { enabled = true },
      snippets = { preset = "luasnip" },
      sources = { default = { "lsp", "path", "snippets", "buffer" } },
    },
    -- 加载第三方和自定义代码片段，然后初始化补全引擎。
    config = function(_, opts)
      require("luasnip.loaders.from_vscode").lazy_load()
      require("config.snippets")
      require("blink.cmp").setup(opts)
    end,
  },
}
