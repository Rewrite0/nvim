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
      local has_tree_sitter = vim.fn.executable("tree-sitter") == 1
      local is_windows = vim.fn.has("win32") == 1

      if has_tree_sitter then
        -- Windows 交由 tree-sitter 自动发现 Visual Studio Build Tools 的 MSVC 环境。
        if is_windows then
          vim.env.CC = nil
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
