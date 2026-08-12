local M = {}

local enabled = true

---@return boolean
function M.is_enabled()
  return enabled
end

---@param value boolean
function M.set_enabled(value)
  enabled = value
end

return M
