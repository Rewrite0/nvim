local map = require("config.utils").map

return {
	{
		"akinsho/toggleterm.nvim",
		config = function()
			local wk = require("which-key")

			map("t", "<esc>", "<C-\\><C-n>")

			require("toggleterm").setup()

			wk.register({
				["<leader>t"] = {
					name = "terminal",
					r = { ":ToggleTerm size=50 direction=vertical name=right<CR>", "Open right terminal" },
					b = { ":ToggleTerm size=20 direction=horizontal name=bottom<CR>", "Open bottom terminal" },
					f = { ":ToggleTerm direction=float name=bottom<CR>", "Open float terminal" },
					c = { ":ToggleTermToggleAll<CR>", "Toggle all terminal" },
				},
			})
		end,
	},
}
