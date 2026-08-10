local M = {}

local modules = {
  "config.options",
  "config.keymaps",
  "config.autocmds",
  "config.languages",
}

function M.reload()
  for _, name in ipairs(modules) do
    package.loaded[name] = nil
    require(name)
  end
  vim.notify("Neovim 配置已重载", vim.log.levels.INFO, { title = "配置" })
end

if vim.fn.exists(":Reload") == 2 then
  vim.api.nvim_del_user_command("Reload")
end
vim.api.nvim_create_user_command("Reload", M.reload, { desc = "重载用户配置" })

return M
