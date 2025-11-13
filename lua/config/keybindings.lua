local utils = require("config.utils")
local map = utils.map
local wk = require("which-key")

-- save
map("n", "<C-s>", ":w<CR>")
map("n", "<leader>s", ":w<CR>")
-- exit
map("n", "<leader>q", ":q<CR>")
map("n", "<leader>Q", ":q!<CR>")

-- 可视模式缩进
map("v", "<", "<gv")
map("v", ">", ">gv")

-- 上下移动选中文本
map("v", "J", ":move '>+1<CR>gv-gv")
map("v", "K", ":move '<-2<CR>gv-gv")

-- 分屏
wk.add({
	{ "<leader>s", group = "split screen" },
	{ "<leader>v", ":vsp<CR>", desc = "vertical split" },
	{ "<leader>h", ":sp<CR>", desc = "horizontal split" },
	{ "<leader>c", "<C-w>c", desc = "close current split" },
	{ "<leader>o", "<C-w>o", desc = "close other split" },
})

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
wk.add({
	{ "<leader>b", group = "+buffer" },
	{ "<leader>bp", ":BufferLineTogglePin<CR>", desc = "Toggle bufferline pin" },
	{ "<leader>bw", ":BufferLinePickClose<CR>", desc = "Pick close buffer" },
})
wk.add({
	{ "<leader>w", utils.close_buffer, desc = "Close buffer" },
})
