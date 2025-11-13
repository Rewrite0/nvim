return {
	"nvim-lua/plenary.nvim",
	"nvim-tree/nvim-web-devicons",
	{
		"folke/neoconf.nvim",
		opts = {
			local_settings = ".neoconf.json",
			global_settings = "neoconf.json",
		},
	},

	-- treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"JoosepAlviste/nvim-ts-context-commentstring",
			"windwp/nvim-ts-autotag",
		},
		init = function()
			-- 代码折叠
			vim.o.foldenable = true
			vim.o.foldcolumn = "1"
			vim.opt.foldmethod = "expr"
			vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
			-- 默认不折叠
			vim.opt.foldlevel = 99
			vim.o.foldlevelstart = 99
		end,
		opts = {
			ensure_installed = {
				"css",
				"graphql",
				"html",
				"javascript",
				"lua",
				"nix",
				"php",
				"python",
				"scss",
				"svelte",
				"tsx",
				"typescript",
				"vim",
				"vue",
				"rust",
				"toml",
				"bash",
				"comment",
				"jsdoc",
				"json",
				"jsonc",
				"markdown",
				"markdown_inline",
			},

			-- 启用代码高亮模块
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
				disable = function(lang, bufnr) -- Disable in large C++ buffers
					return vim.api.nvim_buf_line_count(bufnr) > 10000
				end,
			},

			-- 启用代码缩进模块 (=)
			indent = {
				enable = true,
			},

			context_commentstring = {
				enable = true,
			},

			autotag = {
				enable = true,
			},
		},
	},
}
