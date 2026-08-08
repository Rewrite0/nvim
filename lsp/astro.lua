local project = require("config.project")

return {
  cmd = { "astro-ls", "--stdio" },
  filetypes = { "astro" },
  -- 仅在 Node 项目中为 Astro 文件启动语言服务器。
  root_dir = function(bufnr, on_dir)
    local root = project.node_root(bufnr)
    if root then
      on_dir(root)
    end
  end,
  single_file_support = false,
}
