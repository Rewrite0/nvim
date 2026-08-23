return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufNewFile" },
    -- 配置按项目类型动态选择的 lint 流程。
    config = function()
      local lint = require("lint")
      local languages = require("config.languages")
      local project = require("config.project")
      local group = vim.api.nvim_create_augroup("project_lint", { clear = true })

      -- 某些 ESLint 配置会把提示日志写入 stdout，剥离日志后复用内置 JSON parser。
      local eslint = lint.linters.eslint
      eslint.cmd = function()
        local root = project.eslint_root(vim.api.nvim_get_current_buf())
        if root then
          local local_binary = vim.fs.joinpath(root, "node_modules", ".bin", "eslint")
          if vim.fn.executable(local_binary) == 1 then
            return local_binary
          end
        end
        return "eslint"
      end
      local eslint_parser = eslint.parser
      eslint.parser = function(output, bufnr)
        local json_start = output:find("\n%[%s*{") or output:find("\n%[%s*%]")
        if json_start then
          output = output:sub(json_start + 1)
        end
        return eslint_parser(output, bufnr)
      end

      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = group,
        -- 运行注册表为当前语言和项目选择的 linter。
        callback = function(event)
          local linters = languages.linters_for(event.buf)
          if #linters > 0 then
            lint.try_lint(linters)
          end
        end,
      })

      -- 手动运行与当前项目匹配的 linter。
      vim.keymap.set("n", "<leader>cl", function()
        local linters = languages.linters_for(0)
        if #linters > 0 then
          lint.try_lint(linters)
        end
      end, { desc = "运行 lint" })
    end,
  },
}
