return {
	"nvim-lua/plenary.nvim",
	"nvim-tree/nvim-web-devicons",
	"folke/neoconf.nvim",

	-- treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"JoosepAlviste/nvim-ts-context-commentstring",
			"windwp/nvim-ts-autotag",
		},
		config = function()
			require("nvim-treesitter.configs").setup({
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
			})

			-- 代码折叠
			vim.o.foldenable = true
			vim.o.foldcolumn = "1"
			vim.opt.foldmethod = "expr"
			vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
			-- 默认不折叠
			vim.opt.foldlevel = 99
			vim.o.foldlevelstart = 99
		end,
	},

	-- comment
	{
		"numToStr/Comment.nvim",
		event = "VeryLazy",
		dependencies = {
			"JoosepAlviste/nvim-ts-context-commentstring",
		},
		config = function()
			local keys = {
				line = "<leader>cl",
				block = "<leader>cb",
			}

			require("Comment").setup({
				mappings = {
					extra = false,
				},
				toggler = keys,
				opleader = keys,
				pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
			})
		end,
	},

	-- flash
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		keys = {
			{
				"f",
				mode = { "n", "x", "o" },
				function()
					require("flash").jump()
				end,
				desc = "Flash",
			},
			{
				"F",
				mode = { "n", "x", "o" },
				function()
					require("flash").treesitter()
				end,
				desc = "Flash Treesitter",
			},
			{
				"<c-s>",
				mode = { "c" },
				function()
					require("flash").toggle()
				end,
				desc = "Toggle Flash Search",
			},
		},
		opts = {
			modes = {
				char = {
					keys = { "t", "T", [";"] = ".", "," },
				},
			},
		},
	},
}
