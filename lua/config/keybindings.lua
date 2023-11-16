local utils = require("config.utils")
local map = utils.map

-- leader key 空格
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- save
map("n", "<C-s>", ":w<CR>")
map("n", "<leader>s", ":w<CR>")
-- exit
map("n", "<leader>q", ":q<CR>")
map("n", "<leader>Q", ":q!<CR>")

-- ;进入命令
map("n", ";", ":")

-- 可视模式缩进
map("v", "<", "<gv")
map("v", ">", ">gv")

-- 上下移动选中文本
map("v", "J", ":move '>+1<CR>gv-gv")
map("v", "K", ":move '<-2<CR>gv-gv")

-- 分屏
map("n", "<leader>sv", ":vsp<CR>") -- 水平分屏
map("n", "<leader>sh", ":sp<CR>") -- 垂直分屏
map("n", "<leader>sc", "<C-w>c") -- 关闭当前分屏
map("n", "<leader>so", "<C-w>o") -- 关闭其他分屏

-- 比例控制
-- 左右
map("n", "<A-l>", ":vertical resize +5<CR>")
map("n", "<A-h>", ":vertical resize -5<CR>")
-- 上下
map("n", "<A-k>", ":resize +5<CR>")
map("n", "<A-j>", ":resize -5<CR>")
-- 相等比例
map("n", "<A-=>", "<C-w>=")

-- 分屏窗口跳转
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- buffer
map("n", "<S-h>", ":BufferLineCyclePrev<CR>")
map("n", "<S-l>", ":BufferLineCycleNext<CR>")
map("n", "<leader>bp", ":BufferLineTogglePin<CR>")
map("n", "<leader>bw", ":BufferLinePickClose<CR>")
map("n", "<leader>w", utils.close_buffer, { desc = "close buffer" })

----------------------------
-- plugins
----------------------------

-- open lazy
map("n", "<leader>l", ":Lazy<CR>")
