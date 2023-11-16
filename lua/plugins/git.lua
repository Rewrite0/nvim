return {
	{
		"kdheepak/lazygit.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		keys = {
			{
				"<leader>g",
				":LazyGit<CR>",
				desc = "open lazygit",
			},
		},
		opts = {},
	},

	{
		"lewis6991/gitsigns.nvim",
		event = "VeryLazy",
		opts = {},
	},
}
