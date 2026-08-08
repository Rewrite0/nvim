return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufNewFile" },
    -- 配置按项目类型动态选择的 lint 流程。
    config = function()
      local lint = require("lint")
      local project = require("config.project")
      local group = vim.api.nvim_create_augroup("project_lint", { clear = true })

      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = group,
        -- 仅对支持的前端文件运行 Deno lint 或 ESLint。
        callback = function(event)
          local filetype = vim.bo[event.buf].filetype
          local supported = vim.tbl_contains({
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
            "vue",
            "astro",
          }, filetype)
          if not supported then
            return
          end

          if project.is_deno(event.buf) then
            lint.try_lint("deno")
          elseif project.is_node(event.buf) then
            lint.try_lint("eslint")
          end
        end,
      })

      -- 手动运行与当前项目匹配的 linter。
      vim.keymap.set("n", "<leader>cl", function()
        if project.is_deno(0) then
          lint.try_lint("deno")
        elseif project.is_node(0) then
          lint.try_lint("eslint")
        end
      end, { desc = "运行 lint" })
    end,
  },
}
