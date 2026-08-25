return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      current_line_blame = false,
      -- 为 Gitsigns 已附加的缓冲区注册 Git 块操作。
      on_attach = function(bufnr)
        local gs = require("gitsigns")
        ---注册当前缓冲区的普通模式 Git 快捷键。
        ---@param lhs string
        ---@param rhs string|function
        ---@param desc string
        local map = function(lhs, rhs, desc)
          vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
        end

        -- 跳转到下一个 Git 变更块。
        map("]h", function()
          gs.nav_hunk("next")
        end, "下一个 Git 块")
        -- 跳转到上一个 Git 变更块。
        map("[h", function()
          gs.nav_hunk("prev")
        end, "上一个 Git 块")
        map("<leader>gs", gs.stage_hunk, "暂存 Git 块")
        map("<leader>gr", gs.reset_hunk, "还原 Git 块")
        map("<leader>gp", function()
          local preview = require("utils.preview")
          local source = vim.api.nvim_get_current_win()
          preview.capture_after(function()
            gs.preview_hunk()
          end, source)
        end, "预览 Git 块")
      end,
    },
  },
}
