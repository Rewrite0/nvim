local M = {}

local base_modules = {
  "config.options",
  "config.keymaps",
  "config.autocmds",
}

local function clear_user_modules()
  for name in pairs(package.loaded) do
    if name:match("^config%.") or name:match("^plugins%.") or name:match("^utils%.") then
      package.loaded[name] = nil
    end
  end
end

local function lsp_names(languages)
  local names = {}
  for name in pairs(languages.lsp_configs()) do
    names[name] = true
  end
  return names
end

function M.reload()
  local lazy_config = require("lazy.core.config")
  local old_lsp_names = lsp_names(require("config.languages"))
  local loaded_plugins = {}
  for name, plugin in pairs(lazy_config.plugins) do
    if plugin._.loaded and name ~= "lazy.nvim" then
      loaded_plugins[#loaded_plugins + 1] = name
    end
  end
  table.sort(loaded_plugins)

  clear_user_modules()
  for _, name in ipairs(base_modules) do
    require(name)
  end

  local new_lsp_names = lsp_names(require("config.languages"))
  local removed_lsp_names = {}
  for name in pairs(old_lsp_names) do
    if not new_lsp_names[name] then
      removed_lsp_names[#removed_lsp_names + 1] = name
    end
  end
  if #removed_lsp_names > 0 then
    table.sort(removed_lsp_names)
    vim.lsp.enable(removed_lsp_names, false)
  end

  require("lazy.core.plugin").load()
  local loader = require("lazy.core.loader")
  for _, name in ipairs(loaded_plugins) do
    local plugin = lazy_config.plugins[name]
    if plugin then
      if plugin.init then
        local ok, err = pcall(plugin.init, plugin)
        if not ok then
          vim.notify("重载插件 init 失败 (" .. name .. "): " .. err, vim.log.levels.ERROR)
        end
      end
      if plugin.config or plugin.opts then
        loader.config(plugin)
      end
    end
  end

  if vim.fn.exists(":LspRestart") == 2 then
    vim.cmd("LspRestart")
  end

  vim.api.nvim_exec_autocmds("User", { pattern = "LazyReload", modeline = false })
  require("config.reload")
  vim.notify("Neovim 配置已重载", vim.log.levels.INFO, { title = "配置" })
end

if vim.fn.exists(":Reload") == 2 then
  vim.api.nvim_del_user_command("Reload")
end
vim.api.nvim_create_user_command("Reload", M.reload, { desc = "重载用户配置" })

return M
