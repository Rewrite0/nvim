local map = require("config.utils").map

return {
	{
		"akinsho/toggleterm.nvim",
		init = function()
			local wk = require("which-key")

			map("t", "<esc>", "<C-\\><C-n>")

			require("toggleterm").setup()

			wk.add({
				{ "<leader>t", group = "terminal" },
				{ "<leader>tr", ":ToggleTerm size=50 direction=vertical name=right<CR>", desc = "Open right terminal" },
				{
					"<leader>tb",
					":ToggleTerm size=20 direction=horizontal name=bottom<CR>",
					desc = "Open bottom terminal",
				},
				{ "<leader>tf", ":ToggleTerm direction=float name=bottom<CR>", desc = "Open float terminal" },
				{ "<leader>tc", ":ToggleTermToggleAll<CR>", desc = "Toggle all terminal" },
			})
		end,
	},
}
