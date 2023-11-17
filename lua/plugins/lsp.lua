local lsp = require("config.lsp")
local langs = require("config.langs")
local neoconf = require("neoconf")

return {
	{
		"williamboman/mason.nvim",
		lazy = false,
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"neovim/nvim-lspconfig",
			"mfussenegger/nvim-lint",
			"rshkarin/mason-nvim-lint",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
		},
		build = ":MasonUpdate",
		keys = {
			{
				"<leader>m",
				":Mason<CR>",
				desc = "open Mason",
			},
		},
		config = function()
			local mason_lspconfig = require("mason-lspconfig")
			local lspconfig = require("lspconfig")
			local mason_tool_installer = require("mason-tool-installer")

			require("mason").setup()

			mason_tool_installer.setup({
				ensure_installed = langs.install_list,
				auto_update = true,
			})

			neoconf.setup({
				local_settings = ".neoconf.json",
				global_settings = "neoconf.json",
			})

			mason_lspconfig.setup({
				ensure_installed = langs.servers,
			})

			mason_lspconfig.setup_handlers({
				function(server_name)
					if lsp.disable_clash_lsp(server_name, "tsserver", "volar") then
						return
					end

					if lsp.disable_clash_lsp(server_name, "unocss", "tailwindcss") then
						return
					end

					-- setup lspconfig
					local config = lsp.get_config(server_name)
					lspconfig[server_name].setup(config)
				end,
			})
		end,
	},

	-- lspsaga
	{
		"glepnir/lspsaga.nvim",
		event = "LspAttach",
		dependencies = {
			{ "nvim-tree/nvim-web-devicons" },
			--Please make sure you install markdown and markdown_inline parser
			{ "nvim-treesitter/nvim-treesitter" },
		},
		keys = {
			{
				"gd",
				"<cmd>Lspsaga goto_definition<CR>",
				desc = "goto definition",
			},
			{
				"<leader>ca",
				":Lspsaga code_action<CR>",
				mode = { "n", "v" },
				desc = "code action",
			},
			{
				"<leader>cr",
				":Lspsaga rename<CR>",
				desc = "rename",
			},
			{
				"K",
				":Lspsaga hover_doc<CR>",
				desc = "hover doc",
			},
			{
				"<leader>cpt",
				":Lspsaga peek_type_definition<CR>",
				desc = "peek type definition",
			},
			{
				"<leader>cpd",
				":Lspsaga peek_definition<CR>",
				desc = "peek definition",
			},
			{
				"<leader>cd",
				":Lspsaga show_line_diagnostics<CR>",
				desc = "show line diagnostics",
			},
			{
				"[d",
				":Lspsaga diagnostic_jump_prev<CR>",
				desc = "diagnostic jump prev",
			},
			{
				"]d",
				":Lspsaga diagnostic_jump_next<CR>",
				desc = "diagnostic jump next",
			},
			{
				"[e",
				function()
					require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.ERROR })
				end,
				desc = "jump error prev",
			},
			{
				"]e",
				function()
					require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity.ERROR })
				end,
				desc = "jump error next",
			},
			{
				"<A-;>",
				"<cmd>Lspsaga term_toggle<CR>",
				mode = { "n", "t" },
				desc = "toggle terminal",
			},
		},
		opts = {},
	},

	-- fidget
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

	-- trouble
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
		opts = {},
	},
}
