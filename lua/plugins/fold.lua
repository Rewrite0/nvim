local function fold_virt_text_handler(virt_text, lnum, end_lnum, width, truncate)
  local new_virt_text = {}
  local suffix = (" 󰁂 %d "):format(end_lnum - lnum)
  local suffix_width = vim.fn.strdisplaywidth(suffix)
  local target_width = width - suffix_width
  local current_width = 0

  for _, chunk in ipairs(virt_text) do
    local text = chunk[1]
    local chunk_width = vim.fn.strdisplaywidth(text)
    if current_width + chunk_width < target_width then
      new_virt_text[#new_virt_text + 1] = chunk
      current_width = current_width + chunk_width
    else
      text = truncate(text, math.max(target_width - current_width, 0))
      new_virt_text[#new_virt_text + 1] = { text, chunk[2] }
      local truncated_width = vim.fn.strdisplaywidth(text)
      suffix = suffix .. (" "):rep(math.max(target_width - current_width - truncated_width, 0))
      break
    end
  end

  new_virt_text[#new_virt_text + 1] = { suffix, "MoreMsg" }
  return new_virt_text
end

---返回当前窗口中最深的折叠层级。
---@return integer
local function max_fold_level()
  local level = 0
  for lnum = 1, vim.api.nvim_buf_line_count(0) do
    level = math.max(level, vim.fn.foldlevel(lnum))
  end
  return level
end

---返回当前窗口统一折叠状态对应的可见层级。
---@param max_level integer
---@return integer
local function current_fold_level(max_level)
  local level = max_level
  for lnum = 1, vim.api.nvim_buf_line_count(0) do
    if vim.fn.foldclosed(lnum) == lnum then
      level = math.min(level, math.max(vim.fn.foldlevel(lnum) - 1, 0))
    end
  end
  return level
end

---按数字前缀调整整个窗口的折叠层级。
---@param direction 1|-1
local function adjust_fold_level(direction)
  local ufo = require("ufo")
  local max_level = max_fold_level()
  local level = current_fold_level(max_level)
  local target = math.max(0, math.min(max_level, level + direction * vim.v.count1))

  if target == max_level then
    ufo.openAllFolds()
  else
    ufo.closeFoldsWith(target)
  end
end

return {
  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    event = { "BufReadPost", "BufNewFile" },
    init = function()
      vim.opt.foldcolumn = "1"
      vim.opt.foldlevel = 99
      vim.opt.foldlevelstart = 99
      vim.opt.foldenable = true
      vim.opt.fillchars:append({
        fold = " ",
        foldclose = "",
        foldopen = "",
        foldsep = " ",
      })
    end,
    keys = {
      {
        "zR",
        function()
          require("ufo").openAllFolds()
        end,
        desc = "展开全部折叠",
      },
      {
        "zM",
        function()
          require("ufo").closeAllFolds()
        end,
        desc = "收起全部折叠",
      },
      {
        "zr",
        function()
          adjust_fold_level(1)
        end,
        desc = "展开一层折叠",
      },
      {
        "zm",
        function()
          adjust_fold_level(-1)
        end,
        desc = "收起一层折叠",
      },
      {
        "K",
        function()
          local winid = require("ufo").peekFoldedLinesUnderCursor()
          if not winid then
            vim.lsp.buf.hover()
          end
        end,
        desc = "预览折叠内容或悬浮文档",
      },
    },
    opts = {
      close_fold_current_line_for_ft = { default = false },
      close_fold_kinds_for_ft = { default = {} },
      fold_virt_text_handler = fold_virt_text_handler,
      provider_selector = function()
        return { "treesitter", "indent" }
      end,
    },
  },
}
