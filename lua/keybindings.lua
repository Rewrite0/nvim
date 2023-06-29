local map = require("utils").map

-- leader key 空格
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- 取消默认行为
map("n", "s", "")

-- save
map("n", "<C-s>", ":w<CR>")
map("n", "<leader>s", ":w<CR>")
-- exit
map("n", "<leader>q", ":q<CR>")
map("n", "<leader>Q", ":q!<CR>")

-- 快速翻页
map("n", "<C-k>", "9k")
map("n", "<C-j>", "9j")
map("v", "<C-j>", "5j")
map("v", "<C-k>", "5k")

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
map("n", "s=", "<C-w>=")

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
map("n", "<leader>w", function()
	require("utils").close_buffer()
end, { desc = "close buffer" })

----------------------------
-- plugins
----------------------------

-- open lazy
map("n", "<leader>l", ":Lazy<CR>")

return {
	notify = {
		{
			"<leader>nh",
			":lua require('telescope').extensions.notify.notify()<CR>",
			desc = "notify history",
		},
	},

	telescope = {
		{
			"<leader>ff",
			":Telescope find_files<CR>",
			desc = "find files",
		},
		{
			"<leader>fg",
			":Telescope live_grep<CR>",
			desc = "find live grep",
		},
		{
			"<leader>fb",
			":Telescope buffers<CR>",
			desc = "find buffers",
		},
		{
			"<leader>fh",
			":Telescope help_tags<CR>",
			desc = "find help tags",
		},
		{
			"<leader>/",
			":Telescope search_history<CR>",
			desc = "find search history",
		},
	},

	nvim_tree = {
		{
			"<leader>e",
			":NvimTreeToggle<CR>",
			desc = "toggle nvim tree",
		},
	},

	hop = {
		{
			"f",
			":HopPattern<CR>",
			desc = "HopPattern",
		},
		{
			"F",
			":HopLine<CR>",
			desc = "HopLine",
		},
	},

	mason = {
		{
			"<leader>m",
			":Mason<CR>",
			desc = "open Mason",
		},
	},

	lspsaga = {
		{
			"gd",
			"<cmd>Lspsaga goto_definition<CR>",
			desc = "goto definition",
		},
		{
			"<leader>ca",
			":Lspsaga code_action<CR>",
			mode = { "n", "v" },
			desc = "code action",
		},
		{
			"<leader>cr",
			":Lspsaga rename<CR>",
			desc = "rename",
		},
		{
			"K",
			":Lspsaga hover_doc<CR>",
			desc = "hover doc",
		},
		{
			"<leader>cpt",
			":Lspsaga peek_type_definition<CR>",
			desc = "peek type definition",
		},
		{
			"<leader>cpd",
			":Lspsaga peek_definition<CR>",
			desc = "peek definition",
		},
		{
			"<leader>cd",
			":Lspsaga show_line_diagnostics<CR>",
			desc = "show line diagnostics",
		},
		{
			"[d",
			":Lspsaga diagnostic_jump_prev<CR>",
			desc = "diagnostic jump prev",
		},
		{
			"]d",
			":Lspsaga diagnostic_jump_next<CR>",
			desc = "diagnostic jump next",
		},
		{
			"[e",
			":lua require('lspsaga.diagnostic'):goto_prev({ severity = vim.diagnostic.severity.ERROR })<CR>",
			desc = "jump error prev",
		},
		{
			"]e",
			":lua require('lspsaga.diagnostic'):goto_next({ severity = vim.diagnostic.severity.ERROR })<CR>",
			desc = "jump error next",
		},
		{
			"<A-;>",
			"<cmd>Lspsaga term_toggle<CR>",
			mode = { "n", "t" },
			desc = "toggle terminal",
		},
	},

	trouble = {
		{
			"<leader>xx",
			":TroubleToggle<CR>",
			desc = "trouble toggle",
		},
		{
			"<leader>xw",
			":TroubleToggle workspace_diagnostics<CR>",
			desc = "trouble toggle workspace_diagnostics",
		},
		{
			"<leader>xd",
			":TroubleToggle document_diagnostics<CR>",
			desc = "trouble toggle document_diagnostics",
		},
		{
			"<leader>xl",
			":TroubleToggle loclist<CR>",
			desc = "trouble toggle loclist",
		},
		{
			"<leader>xq",
			":TroubleToggle quickfix<CR>",
			desc = "trouble toggle quickfix",
		},
		{
			"<leader>xr",
			":TroubleToggle lsp_references<CR>",
			desc = "trouble toggle lsp_references",
		},
	},
}
