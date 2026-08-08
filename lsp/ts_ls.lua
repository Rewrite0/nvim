local project = require("config.project")

return {
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
  },
  -- 仅在不属于 Deno 的 Node 项目中启动 ts_ls。
  root_dir = function(bufnr, on_dir)
    local root = project.node_root(bufnr)
    if root then
      on_dir(root)
    end
  end,
  single_file_support = false,
}
