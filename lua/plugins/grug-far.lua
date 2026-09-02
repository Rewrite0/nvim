return {
  {
    "MagicDuck/grug-far.nvim",
    cmd = "GrugFar",
    keys = {
      {
        "<leader>fR",
        function()
          require("grug-far").open()
        end,
        desc = "全局搜索替换",
      },
    },
    opts = {
      keymaps = {
        close = { n = "q" },
      },
      transient = true,
      windowCreationCommand = "GrugFarFloat",
    },
    config = function(_, opts)
      vim.api.nvim_create_user_command("GrugFarFloat", function()
        local width = math.max(1, math.floor(vim.o.columns * 0.9))
        local available_height = vim.o.lines - vim.o.cmdheight - 2
        local height = math.max(1, math.floor(available_height * 0.9))
        local buf = vim.api.nvim_create_buf(false, true)

        vim.api.nvim_open_win(buf, true, {
          relative = "editor",
          width = width,
          height = height,
          row = math.floor((available_height - height) / 2),
          col = math.floor((vim.o.columns - width) / 2),
          style = "minimal",
          border = "rounded",
          title = " 搜索替换 ",
          title_pos = "center",
        })
      end, {})

      require("grug-far").setup(opts)
    end,
  },
}
