return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    lazy = false,
    -- 安装目标解析器，并为各文件类型启用高亮和缩进。
    config = function()
      local parsers = require("config.languages").treesitter_parsers()

      local treesitter = require("nvim-treesitter")
      treesitter.setup({})
      if vim.fn.executable("tree-sitter") == 1 then
        -- Windows 上 tree-sitter 默认尝试使用 cl.exe；优先复用用户已设置的
        -- CC，否则自动回退到 PATH 中可用的 clang 或 gcc。
        if vim.env.CC == nil or vim.env.CC == "" then
          for _, compiler in ipairs({ "clang", "gcc" }) do
            if vim.fn.executable(compiler) == 1 then
              vim.env.CC = vim.fn.exepath(compiler)
              break
            end
          end
        end
        treesitter.install(parsers)
      else
        -- 等待启动流程结束后提示缺少的系统依赖。
        vim.schedule(function()
          vim.notify(
            "Treesitter parser 尚未安装：请先通过系统包管理器安装 tree-sitter-cli >= 0.26.1，再执行 :TSInstall all",
            vim.log.levels.WARN
          )
        end)
      end
      vim.api.nvim_create_autocmd("FileType", {
        desc = "启用 Treesitter 高亮和缩进",
        -- 为当前缓冲区启动 Treesitter，并设置其缩进表达式。
        callback = function(event)
          pcall(vim.treesitter.start, event.buf)
          vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },
}
