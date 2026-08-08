return {
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {},
    keys = {
      {
        "<leader>ps",
        function()
          require("persistence").load()
        end,
        desc = "恢复当前目录会话",
      },
      {
        "<leader>pS",
        function()
          require("persistence").select()
        end,
        desc = "选择会话",
      },
      {
        "<leader>pl",
        function()
          require("persistence").load({ last = true })
        end,
        desc = "恢复最近会话",
      },
      {
        "<leader>pd",
        function()
          require("persistence").stop()
        end,
        desc = "停止保存会话",
      },
    },
  },
}
