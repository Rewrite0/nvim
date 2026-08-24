return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    lazy = false,
    opts = {
      custom_highlights = function(colors)
        return {
          DiagnosticUnnecessary = { fg = colors.overlay0 },
          FrameworkComponentTag = { fg = colors.pink },
          ["@lsp.type.component"] = { link = "FrameworkComponentTag" },
          ["@lsp.type.component.vue"] = { link = "FrameworkComponentTag" },
          ["@tag.framework"] = { link = "FrameworkComponentTag" },
          ["@tag.javascript"] = { link = "FrameworkComponentTag" },
          ["@tag.tsx"] = { link = "FrameworkComponentTag" },
          ["@type.astro"] = { link = "FrameworkComponentTag" },
        }
      end,
    },
    -- 应用 Catppuccin 配置并切换到对应配色。
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin-macchiato")
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "catppuccin",
        component_separators = "|",
        section_separators = "",
        globalstatus = true,
      },
    },
  },
  {
    "folke/snacks.nvim",
    priority = 900,
    lazy = false,
    opts = {
      bigfile = {},
      bufdelete = {},
      dim = {},
      dashboard = {},
      explorer = {},
      gitbrowse = {},
      image = {},
      indent = {},
      input = {},
      notifier = {},
      picker = {
        sources = {
          buffers = {
            win = {
              input = {
                keys = {
                  ["dd"] = { "bufdelete", mode = "n" },
                },
              },
              list = {
                keys = {
                  ["dd"] = "bufdelete",
                },
              },
            },
          },
        },
      },
      quickfile = {},
      rename = {},
      scratch = {},
      scope = {},
      statuscolumn = {},
      terminal = {},
      toggle = {},
      words = {},
      scroll = {},
      zen = {},
    },
    config = function(_, opts)
      require("snacks").setup(opts)
      local format = require("config.format")

      Snacks.toggle.diagnostics():map("<leader>ud")
      Snacks.toggle.inlay_hints():map("<leader>uh")
      Snacks.toggle
        .new({
          name = "保存时格式化",
          get = format.is_enabled,
          set = format.set_enabled,
        })
        :map("<leader>uf")
      Snacks.toggle.option("spell", { name = "拼写检查" }):map("<leader>us")
    end,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "helix",
      spec = {
        { "<leader><Tab>", group = "Tab" },
        { "<leader>b", group = "Buffer" },
        { "<leader>f", group = "查找" },
        { "<leader>g", group = "Git" },
        { "<leader>c", group = "代码" },
        { "<leader>c", mode = "x", group = "代码" },
        { "<leader>p", group = "会话" },
        { "<leader>s", group = "代码片段" },
        { "<leader>s", mode = "x", group = "代码片段" },
        { "<leader>t", group = "终端" },
        { "<leader>u", group = "开关" },
        { "<leader>x", group = "列表" },
      },
    },
  },
}
