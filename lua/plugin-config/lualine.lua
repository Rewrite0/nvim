local function ai_status()
	-- return "ai:" .. vim.fn["codeium#GetStatusString"]()
	local notAuth = "Copilot: Not authenticated. Invoke :Copilot setup"
	local disabled = "Copilot: Disabled globally by :Copilot disable"
	local enabled = "Copilot: Enabled and online"
	local status = vim.api.nvim_exec("Copilot status", true)
	if status == disabled then
		return "ai: Disabled"
	elseif status == notAuth then
		return "ai: NoAuth"
	elseif status == enabled then
		return "ai: Enabled"
	end
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
			{ ai_status },
			"filesize",
			{
				"fileformat",
				symbols = {
					unix = "LF",
					dos = "CRLF",
					mac = "CR",
				},
			},
			"encoding",
			"filetype",
		},
	},
})
