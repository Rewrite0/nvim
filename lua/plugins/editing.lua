local langs = require("config.langs")

return {
	{
		"stevearc/conform.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local conform = require("conform")

			conform.setup({
				formatters_by_ft = langs.formatters_by_ft,
				format_on_save = {
					lsp_fallback = true,
					timeout_ms = 1000,
				},
			})

			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = "*",
				callback = function(args)
					require("conform").format({ bufnr = args.buf })
				end,
			})
		end,
	},

	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local lint = require("lint")

			lint.linters_by_ft = langs.linters_by_ft

			local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

			vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
				group = lint_augroup,
				callback = function()
					lint.try_lint()
				end,
			})
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
		},
		opts = {
			modes = {
				char = {
					keys = { "t", "T", ";", "," },
				},
			},
		},
	},
}
