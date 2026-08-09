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
      dashboard = { enabled = true },
      explorer = { enabled = true },
      indent = { enabled = true },
      input = { enabled = true },
      notifier = { enabled = true },
      picker = { enabled = true },
      quickfile = { enabled = true },
      scope = { enabled = true },
      words = { enabled = true },
    },
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
      spec = {
        { "<leader>f", group = "查找" },
        { "<leader>g", group = "Git" },
        { "<leader>c", group = "代码" },
        { "<leader>p", group = "会话" },
      },
    },
  },
}
