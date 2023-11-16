return {
	-- lualine
	{
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			"jonahgoldwastaken/copilot-status.nvim",
		},
		lazy = false,
		config = function()
			local function ai_status()
				-- return "ai:" .. vim.fn["codeium#GetStatusString"]()
				return require("copilot_status").status_string()
			end

			require("lualine").setup({
				options = {
					-- 指定皮肤
					-- https://github.com/nvim-lualine/lualine.nvim/blob/master/THEMES.md
					theme = "auto",
					-- 分割线
					component_separators = {
						left = "|",
						right = "|",
					},
					globalstatus = true,
				},
				extensions = { "nvim-tree" },
				sections = {
					lualine_x = {
						{
							ai_status,
							cond = function()
								return require("copilot_status").enabled()
							end,
						},
						"filesize",
						{
							"fileformat",
							symbols = {
								unix = "",
								dos = "",
								mac = "",
							},
						},
						"encoding",
						"filetype",
					},
				},
			})
		end,
	},

	-- copilot status
	{
		"jonahgoldwastaken/copilot-status.nvim",
		dependencies = { "zbirenbaum/copilot.lua" },
		event = "BufReadPost",
		config = function()
			require("copilot_status").setup({
				icons = {
					idle = "",
					error = "",
					offline = "",
					warning = "",
					loading = "",
				},
				debug = false,
			})
		end,
	},
}
