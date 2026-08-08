return {
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    opts = {},
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", desc = "诊断列表" },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<CR>",
        desc = "当前 Buffer 诊断",
      },
      { "<leader>xs", "<cmd>Trouble symbols toggle focus=false<CR>", desc = "符号列表" },
      {
        "<leader>xl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<CR>",
        desc = "LSP 列表",
      },
      { "<leader>xq", "<cmd>Trouble qflist toggle<CR>", desc = "Quickfix 列表" },
      { "<leader>xL", "<cmd>Trouble loclist toggle<CR>", desc = "Location 列表" },
    },
  },
}
