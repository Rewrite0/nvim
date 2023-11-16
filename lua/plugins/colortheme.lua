return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	lazy = false,
	config = function()
		-- catppuccin-latte,
		-- catppuccin-frappe,
		-- catppuccin-macchiato,
		-- catppuccin-mocha
		vim.cmd([[colorscheme catppuccin-macchiato]])
	end,
}
