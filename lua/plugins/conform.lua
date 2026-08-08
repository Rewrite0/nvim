return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    -- 根据当前项目类型生成 Conform 配置。
    opts = function()
      local project = require("config.project")

      ---选择当前缓冲区使用的格式化器。
      ---@param bufnr integer
      ---@return table?
      local function format_options(bufnr)
        if project.is_deno(bufnr) then
          return { formatters = { "deno_fmt" }, timeout_ms = 2000 }
        end
        if project.is_node(bufnr) then
          return { formatters = { "prettier" }, timeout_ms = 2000 }
        end
      end

      -- 手动格式化时优先使用项目格式化器，否则回退到 LSP。
      vim.keymap.set({ "n", "x" }, "<leader>cf", function()
        local opts = format_options(0) or { lsp_format = "fallback", timeout_ms = 2000 }
        require("conform").format(opts)
      end, { desc = "格式化" })

      return {
        notify_on_error = false,
        format_on_save = format_options,
      }
    end,
  },
}
