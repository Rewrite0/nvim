return {
	{
		"nvim-telescope/telescope.nvim",
		keys = {
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
		dependencies = "nvim-lua/plenary.nvim",
	},
}
