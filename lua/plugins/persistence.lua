local function cleanup_directory_entries()
  local args = vim.fn.argv()
  local file_args = vim.tbl_filter(function(arg)
    return vim.fn.isdirectory(vim.fn.fnamemodify(arg, ":p")) == 0
  end, args)

  if #file_args ~= #args then
    vim.cmd("%argdelete")
    for _, arg in ipairs(file_args) do
      vim.cmd.argadd({ args = { arg } })
    end
  end

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local name = vim.api.nvim_buf_get_name(buf)
    if name ~= "" and vim.fn.isdirectory(name) == 1 and #vim.fn.win_findbuf(buf) == 0 then
      pcall(vim.api.nvim_buf_delete, buf, { force = true })
    end
  end
end

local saved_sessionoptions
local pending_explorer_state

local function explorer_state_path(session)
  return session .. ".explorer.json"
end

local function capture_explorer_state()
  local explorer = Snacks.picker.get({ source = "explorer" })[1]
  pending_explorer_state = {
    session = require("persistence").current(),
    open = explorer ~= nil,
    focused = explorer ~= nil and explorer:is_focused(),
  }
end

local function save_explorer_state()
  if not pending_explorer_state then
    return
  end

  local state = pending_explorer_state
  pending_explorer_state = nil
  pcall(
    vim.fn.writefile,
    { vim.json.encode({ open = state.open, focused = state.focused }) },
    explorer_state_path(state.session)
  )
end

local function restore_explorer()
  local session = vim.v.this_session
  if session == "" then
    return
  end

  local ok, lines = pcall(vim.fn.readfile, explorer_state_path(session))
  if not ok or #lines == 0 then
    return
  end

  local decoded, state = pcall(vim.json.decode, table.concat(lines, "\n"))
  if not decoded or type(state) ~= "table" or state.open ~= true then
    return
  end

  vim.schedule(function()
    if #Snacks.picker.get({ source = "explorer" }) > 0 then
      return
    end

    local editor_win = vim.api.nvim_get_current_win()
    Snacks.explorer()
    if not state.focused and vim.api.nvim_win_is_valid(editor_win) then
      vim.api.nvim_set_current_win(editor_win)
    end
  end)
end

local function exclude_blank_windows()
  if not saved_sessionoptions then
    saved_sessionoptions = vim.o.sessionoptions
  end
  vim.opt.sessionoptions:remove("blank")
end

local function restore_sessionoptions()
  if saved_sessionoptions then
    vim.o.sessionoptions = saved_sessionoptions
    saved_sessionoptions = nil
  end
end

return {
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {},
    config = function(_, opts)
      require("persistence").setup(opts)

      vim.api.nvim_create_autocmd("User", {
        group = vim.api.nvim_create_augroup("project_persistence", { clear = true }),
        pattern = "PersistenceSavePre",
        callback = function()
          cleanup_directory_entries()
          capture_explorer_state()
          exclude_blank_windows()
        end,
        desc = "保存会话前记录目录树并清理目录条目和空白窗口",
      })

      vim.api.nvim_create_autocmd("User", {
        group = "project_persistence",
        pattern = "PersistenceSavePost",
        callback = function()
          restore_sessionoptions()
          save_explorer_state()
        end,
        desc = "保存会话后保存目录树状态并恢复会话选项",
      })

      vim.api.nvim_create_autocmd("User", {
        group = "project_persistence",
        pattern = "PersistenceLoadPost",
        callback = function()
          cleanup_directory_entries()
          restore_explorer()
        end,
        desc = "恢复会话后清理目录 Buffer 并恢复目录树",
      })
    end,
    keys = {
      {
        "<leader>ps",
        function()
          require("persistence").load()
        end,
        desc = "恢复当前目录会话",
      },
      {
        "<leader>pS",
        function()
          require("persistence").select()
        end,
        desc = "选择会话",
      },
      {
        "<leader>pl",
        function()
          require("persistence").load({ last = true })
        end,
        desc = "恢复最近会话",
      },
      {
        "<leader>pd",
        function()
          require("persistence").stop()
        end,
        desc = "停止保存会话",
      },
    },
  },
}
