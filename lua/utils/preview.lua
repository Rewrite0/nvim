local M = {}

local source_win
local preview_win

local function valid(winid)
  return winid and vim.api.nvim_win_is_valid(winid)
end

local function find_float(source, known)
  local candidate
  for _, winid in ipairs(vim.api.nvim_list_wins()) do
    if winid ~= source and winid ~= known and valid(winid) then
      local config = vim.api.nvim_win_get_config(winid)
      if config.relative ~= "" and config.focusable ~= false then
        candidate = winid
      end
    end
  end
  return candidate
end

function M.register(winid, source)
  if valid(winid) then
    source_win = source or vim.api.nvim_get_current_win()
    preview_win = winid
  end
  return winid
end

function M.register_latest(source, known)
  local winid = find_float(source, known)
  if winid then
    M.register(winid, source)
  end
  return winid
end

function M.toggle_focus()
  if not valid(preview_win) then
    preview_win = nil
    source_win = nil
    return
  end

  local current = vim.api.nvim_get_current_win()
  if current == preview_win then
    if valid(source_win) then
      vim.api.nvim_set_current_win(source_win)
    end
  else
    source_win = current
    vim.api.nvim_set_current_win(preview_win)
  end
end

function M.capture_after(action, source)
  local known = preview_win
  local captured = false
  action()
  local function capture()
    if captured then
      return
    end
    captured = M.register_latest(source, known) ~= nil
  end

  vim.schedule(capture)
  vim.defer_fn(capture, 50)
  vim.defer_fn(capture, 150)
end

return M
