local map = vim.keymap.set

map("n", "<Esc>", "<cmd>nohlsearch<CR>")
map("n", "<C-h>", "<C-w><C-h>", { desc = "聚焦左侧窗口" })
map("n", "<C-j>", "<C-w><C-j>", { desc = "聚焦下方窗口" })
map("n", "<C-k>", "<C-w><C-k>", { desc = "聚焦上方窗口" })
map("n", "<C-l>", "<C-w><C-l>", { desc = "聚焦右侧窗口" })
map("n", "<leader>w", "<cmd>confirm bdelete<CR>", { desc = "关闭当前标签" })
map("n", "<leader>s", "<cmd>write<CR>", { desc = "保存文件" })
map("n", "<leader>q", "<cmd>confirm quit<CR>", { desc = "关闭窗口" })
map("n", "<leader>m", "<cmd>Mason<CR>", { desc = "打开 Mason" })
map("n", "<leader>l", "<cmd>Lazy<CR>", { desc = "打开 Lazy" })
map("n", "<S-h>", "<cmd>BufferLineCyclePrev<CR>", { desc = "上一个标签" })
map("n", "<S-l>", "<cmd>BufferLineCycleNext<CR>", { desc = "下一个标签" })
map("n", "<leader>bd", "<cmd>BufferLinePickClose<CR>", { desc = "关闭选中标签" })

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
