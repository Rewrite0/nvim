local map = vim.keymap.set

---沿指定方向移动当前窗口相邻的分隔线。
---@param direction "left"|"right"|"up"|"down"
---@param amount integer
local function move_window_separator(direction, amount)
  local current = vim.api.nvim_get_current_win()
  local neighbors = {
    left = vim.fn.win_getid(vim.fn.winnr("h")),
    right = vim.fn.win_getid(vim.fn.winnr("l")),
    up = vim.fn.win_getid(vim.fn.winnr("k")),
    down = vim.fn.win_getid(vim.fn.winnr("j")),
  }

  if direction == "left" then
    vim.fn.win_move_separator(neighbors.left ~= current and neighbors.left or current, -amount)
  elseif direction == "right" then
    local target = neighbors.right ~= current and current or neighbors.left
    vim.fn.win_move_separator(target, amount)
  elseif direction == "up" then
    vim.fn.win_move_statusline(neighbors.up ~= current and neighbors.up or current, -amount)
  else
    local target = neighbors.down ~= current and current or neighbors.up
    vim.fn.win_move_statusline(target, amount)
  end
end

map("n", "<Esc>", "<cmd>nohlsearch<CR>")
map("n", ";", ":", { desc = "进入命令行" })
map("n", "<C-h>", "<C-w><C-h>", { desc = "聚焦左侧窗口" })
map("n", "<C-j>", "<C-w><C-j>", { desc = "聚焦下方窗口" })
map("n", "<C-k>", "<C-w><C-k>", { desc = "聚焦上方窗口" })
map("n", "<C-l>", "<C-w><C-l>", { desc = "聚焦右侧窗口" })
for lhs, spec in pairs({
  ["<Left>"] = { direction = "left", label = "左" },
  ["<Right>"] = { direction = "right", label = "右" },
  ["<Up>"] = { direction = "up", label = "上" },
  ["<Down>"] = { direction = "down", label = "下" },
}) do
  map("n", lhs, function()
    move_window_separator(spec.direction, 5)
  end, { desc = "向" .. spec.label .. "移动窗口分隔线" })
  map("n", "<C-" .. lhs:sub(2), function()
    move_window_separator(spec.direction, 1)
  end, { desc = "向" .. spec.label .. "微调窗口分隔线" })
end
map("n", "<leader>w", "<cmd>write<CR>", { desc = "保存文件" })
map("n", "<C-s>", "<cmd>write<CR>", { desc = "保存文件" })
map("n", "<leader>q", "<cmd>confirm quit<CR>", { desc = "关闭窗口" })
map("n", "<leader>m", "<cmd>Mason<CR>", { desc = "打开 Mason" })
map("n", "<leader>l", "<cmd>Lazy<CR>", { desc = "打开 Lazy" })
map("n", "<S-h>", "<cmd>BufferLineCyclePrev<CR>", { desc = "上一个标签" })
map("n", "<S-l>", "<cmd>BufferLineCycleNext<CR>", { desc = "下一个标签" })
map("n", "<leader>bp", "<cmd>BufferLinePick<CR>", { desc = "切换到选中标签" })
map("n", "<leader>bd", "<cmd>BufferLinePickClose<CR>", { desc = "关闭选中标签" })
map("n", "<leader>bl", "<cmd>BufferLineCloseLeft<CR>", { desc = "关闭左侧标签" })
map("n", "<leader>br", "<cmd>BufferLineCloseRight<CR>", { desc = "关闭右侧标签" })
map("n", "<leader>bo", "<cmd>BufferLineCloseOthers<CR>", { desc = "关闭其他标签" })
map("n", "<leader>bc", function()
  Snacks.bufdelete()
end, { desc = "关闭当前标签" })

-- 使用 Snacks Picker 查找文件。
map("n", "<leader>ff", function()
  Snacks.picker.files()
end, { desc = "查找文件" })
-- 使用 Snacks Picker 全文搜索。
map("n", "<leader>fg", function()
  Snacks.picker.grep()
end, { desc = "全文搜索" })
-- 使用 Snacks Picker 切换缓冲区。
map("n", "<leader>fb", function()
  Snacks.picker.buffers()
end, { desc = "查找缓冲区" })
-- 使用 Snacks Picker 打开最近文件。
map("n", "<leader>fr", function()
  Snacks.picker.recent()
end, { desc = "最近文件" })
-- 查看当前 Neovim 会话中的通知历史。
map("n", "<leader>fn", function()
  Snacks.picker.notifications()
end, { desc = "通知历史" })
-- 打开 Snacks 文件浏览器。
map("n", "<leader>e", function()
  Snacks.explorer()
end, { desc = "文件浏览器" })
-- 在 Snacks 浮动终端中打开 Lazygit。
map("n", "<leader>gg", function()
  Snacks.lazygit()
end, { desc = "Lazygit" })
-- 显示当前行的 Git 追溯信息。
map("n", "<leader>gb", function()
  Snacks.git.blame_line()
end, { desc = "Git 行追溯" })
-- 在当前符号的 LSP 引用之间循环跳转。
map("n", "]r", function()
  Snacks.words.jump(1, true)
end, { desc = "下一个符号引用" })
map("n", "[r", function()
  Snacks.words.jump(-1, true)
end, { desc = "上一个符号引用" })
map("n", "<leader>.", function()
  Snacks.scratch()
end, { desc = "临时缓冲区" })
map("n", "<leader>S", function()
  Snacks.scratch.select()
end, { desc = "选择临时缓冲区" })
map("n", "<leader>z", function()
  Snacks.zen()
end, { desc = "专注模式" })
map("n", "<leader>go", function()
  Snacks.gitbrowse()
end, { desc = "在浏览器打开 Git 文件" })
map("n", "<leader>tt", function()
  Snacks.terminal()
end, { desc = "切换终端" })
map("n", "<leader>tf", function()
  Snacks.terminal(nil, {
    count = 0,
    win = { position = "float" },
  })
end, { desc = "切换浮动终端" })
map("n", "<leader>tr", function()
  Snacks.terminal(nil, {
    count = -1,
    win = { position = "right" },
  })
end, { desc = "切换右侧终端" })
