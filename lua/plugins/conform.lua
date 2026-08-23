return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      { "<leader>cf", mode = { "n", "x" }, desc = "格式化" },
    },
    -- 根据当前项目类型生成 Conform 配置。
    opts = function()
      local format = require("config.format")
      local languages = require("config.languages")
      local project = require("config.project")
      local eslint = require("utils.eslint")

      ---选择当前缓冲区使用的格式化器。
      ---@param bufnr integer
      ---@return table?
      local function format_options(bufnr)
        if project.is_antfu_eslint(bufnr) then
          return nil
        end
        local formatters = languages.formatters_for(bufnr)
        if #formatters > 0 then
          return { formatters = formatters, timeout_ms = 2000 }
        end
      end

      ---选择保存时使用的格式化器。
      ---@param bufnr integer
      ---@return table?
      local function format_on_save(bufnr)
        if format.is_enabled() then
          return format_options(bufnr)
        end
      end

      -- 手动格式化时优先使用项目格式化器，否则回退到 LSP。
      vim.keymap.set({ "n", "x" }, "<leader>cf", function()
        if project.is_antfu_eslint(0) and eslint.is_attached(0) then
          eslint.fix(0)
          return
        end
        local opts = format_options(0) or { lsp_format = "fallback", timeout_ms = 2000 }
        require("conform").format(opts)
      end, { desc = "格式化" })

      return {
        notify_on_error = false,
        format_on_save = format_on_save,
      }
    end,
  },
}
