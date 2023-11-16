return {
	{
		"j-hui/fidget.nvim",
		event = { "BufReadPre", "BufNewFile" },
		-- enabled = not values.use_noice,
		dependencies = { "neovim/nvim-lspconfig" },
		config = function()
			require("fidget").setup({
				progress = {
					poll_rate = 60,
				},
				notification = {
					poll_rate = 60,
					override_vim_notify = true,
					window = {
						max_width = 120,
					},
				},
			})
		end,
	},

	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		keys = {
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
		opts = require("plugin-config.trouble"),
	},
}
