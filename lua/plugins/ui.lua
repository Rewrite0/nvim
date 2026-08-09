return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    lazy = false,
    -- 应用 Catppuccin 配置并切换到对应配色。
    config = function()
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
      picker = {},
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
      Snacks.toggle.diagnostics():map("<leader>ud")
      Snacks.toggle.inlay_hints():map("<leader>uh")
      Snacks.toggle.option("spell", { name = "拼写检查" }):map("<leader>us")
    end,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "helix",
      spec = {
        { "<leader>b", group = "Buffer" },
        { "<leader>f", group = "查找" },
        { "<leader>g", group = "Git" },
        { "<leader>c", group = "代码" },
        { "<leader>p", group = "会话" },
        { "<leader>t", group = "终端" },
        { "<leader>u", group = "开关" },
        { "<leader>x", group = "列表" },
      },
    },
  },
}
