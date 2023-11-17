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
wk.register({
	["<leader>s"] = {
		name = "split screen",
		v = { ":vsp<CR>", "vertical split" },
		h = { ":sp<CR>", "horizontal split" },
		c = { "<C-w>c", "close current split" },
		o = { "<C-w>o", "close other split" },
	},
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
wk.register({
	["<leader>b"] = { name = "+buffer" },
	["<leader>bp"] = { ":BufferLineTogglePin<CR>", "Toggle bufferline pin" },
	["<leader>bw"] = { ":BufferLinePickClose<CR>", "Pick close buffer" },
	["<leader>w"] = { utils.close_buffer, "Close buffer" },
})
