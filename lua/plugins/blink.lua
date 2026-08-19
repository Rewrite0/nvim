return {
  {
    "saghen/blink.cmp",
    version = "1.*",
    event = "InsertEnter",
    dependencies = {
      "nvim-mini/mini.snippets",
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
      snippets = { preset = "mini_snippets" },
      sources = { default = { "lsp", "path", "snippets", "buffer" } },
    },
  },
}
