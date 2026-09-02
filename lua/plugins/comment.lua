local function toggle_current_line()
  require("Comment.api").toggle.linewise.current()
end

local function toggle_selection_blockwise()
  local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
  vim.api.nvim_feedkeys(esc, "nx", false)
  require("Comment.api").toggle.blockwise(vim.fn.visualmode())
end

return {
  {
    "numToStr/Comment.nvim",
    opts = {},
    keys = {
      {
        "<C-/>",
        toggle_current_line,
        desc = "切换当前行注释",
      },
      {
        "<C-/>",
        mode = "x",
        toggle_selection_blockwise,
        desc = "切换选区块注释",
      },
      {
        "<C-_>",
        toggle_current_line,
        desc = "切换当前行注释",
      },
      {
        "<C-_>",
        mode = "x",
        toggle_selection_blockwise,
        desc = "切换选区块注释",
      },
    },
  },
}
