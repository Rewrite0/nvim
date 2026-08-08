local project = require("config.project")

return {
  cmd = { "deno", "lsp" },
  filetypes = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
  },
  -- 仅在向上找到 Deno 配置文件时启动 denols。
  root_dir = function(bufnr, on_dir)
    local root = project.deno_root(bufnr)
    if root then
      on_dir(root)
    end
  end,
  single_file_support = false,
  init_options = {
    enable = true,
    lint = false,
    unstable = true,
  },
}
