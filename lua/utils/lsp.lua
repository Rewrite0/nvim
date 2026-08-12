local M = {}

---重启指定名称的 LSP，并在旧客户端退出后重新启用配置。
---@param names string[]
---@param callback? fun()
function M.restart(names, callback)
  if #names == 0 then
    if callback then
      callback()
    end
    return
  end

  local targets = {}
  for _, name in ipairs(names) do
    targets[name] = true
  end

  vim.lsp.enable(names, false)
  local started_at = vim.uv.now()
  local function enable_when_stopped()
    for _, client in ipairs(vim.lsp.get_clients()) do
      if targets[client.name] and vim.uv.now() - started_at < 5000 then
        vim.defer_fn(enable_when_stopped, 50)
        return
      end
    end

    vim.lsp.enable(names)
    if callback then
      callback()
    end
  end
  enable_when_stopped()
end

return M
