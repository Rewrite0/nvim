local M = {}

---@param bufnr integer
---@return boolean
function M.is_attached(bufnr)
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr, name = "eslint" })) do
    if client.is_stopped and not client:is_stopped() then
      return true
    end
  end
  return false
end

---@param bufnr integer
function M.fix(bufnr)
  for _, name in ipairs({ "LspEslintFixAll", "EslintFixAll" }) do
    if vim.api.nvim_buf_call(bufnr, function()
      return vim.fn.exists(":" .. name) == 2
    end) then
      vim.api.nvim_buf_call(bufnr, function()
        vim.cmd(name)
      end)
      return
    end
  end

  local client
  for _, attached in ipairs(vim.lsp.get_clients({ bufnr = bufnr, name = "eslint" })) do
    if not attached.is_stopped or not attached:is_stopped() then
      client = attached
      break
    end
  end
  if not client then
    return
  end

  client:request_sync("workspace/executeCommand", {
    command = "eslint.applyAllFixes",
    arguments = {
      {
        uri = vim.uri_from_bufnr(bufnr),
        version = vim.lsp.util.buf_versions[bufnr],
      },
    },
  }, 5000, bufnr)
end

return M
