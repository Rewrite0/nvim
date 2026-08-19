local function cleanup_directory_entries()
  local args = vim.fn.argv()
  local file_args = vim.tbl_filter(function(arg)
    return vim.fn.isdirectory(vim.fn.fnamemodify(arg, ":p")) == 0
  end, args)

  if #file_args ~= #args then
    vim.cmd("%argdelete")
    for _, arg in ipairs(file_args) do
      vim.cmd.argadd({ args = { arg } })
    end
  end

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local name = vim.api.nvim_buf_get_name(buf)
    if name ~= "" and vim.fn.isdirectory(name) == 1 and #vim.fn.win_findbuf(buf) == 0 then
      pcall(vim.api.nvim_buf_delete, buf, { force = true })
    end
  end
end

return {
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {},
    config = function(_, opts)
      require("persistence").setup(opts)

      vim.api.nvim_create_autocmd("User", {
        group = vim.api.nvim_create_augroup("project_persistence", { clear = true }),
        pattern = { "PersistenceSavePre", "PersistenceLoadPost" },
        callback = cleanup_directory_entries,
        desc = "会话保存和恢复时清理目录 Buffer",
      })
    end,
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
