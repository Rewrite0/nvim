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
      keymap = {
        preset = "enter",
        ["<C-j>"] = { "select_next", "fallback" },
        ["<C-k>"] = { "select_prev", "fallback" },
        ["<Tab>"] = { "snippet_forward", "select_next", "fallback" },
        ["<S-Tab>"] = { "snippet_backward", "select_prev", "fallback" },
      },
      cmdline = {
        keymap = {
          preset = "cmdline",
          ["<CR>"] = { "accept_and_enter", "fallback" },
        },
        completion = {
          list = {
            selection = { preselect = false, auto_insert = true },
          },
          menu = {
            auto_show = true,
          },
        },
        sources = { "buffer", "cmdline" },
      },
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
      local vscode_loader = require("luasnip.loaders.from_vscode")
      vscode_loader.lazy_load()
      vscode_loader.lazy_load({ paths = vim.fn.stdpath("config") .. "/snippets" })
      require("config.snippets")
      require("blink.cmp").setup(opts)
    end,
  },
}
