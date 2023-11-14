local keys = require("keybindings")

require("lazy").setup({
	-- theme
	{
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
	},
	-- {
	-- 	"folke/tokyonight.nvim",
	-- 	lazy = false,
	-- 	priority = 1000,
	-- 	config = function()
	-- 		vim.cmd([[colorscheme tokyonight]])
	-- 	end,
	-- },

	"nvim-lua/plenary.nvim",
	"nvim-tree/nvim-web-devicons",

	-- notify
	{
		"rcarriga/nvim-notify",
		lazy = false,
		keys = keys.notify,
		config = function()
			require("plugin-config.nvim-notify")
		end,
	},

	-- telescope
	{
		"nvim-telescope/telescope.nvim",
		keys = keys.telescope,
		dependencies = "nvim-lua/plenary.nvim",
	},

	-- nvim-tree
	{
		"nvim-tree/nvim-tree.lua",
		lazy = false,
		dependencies = "nvim-tree/nvim-web-devicons",
		keys = keys.nvim_tree,
		config = function()
			require("plugin-config.nvim-tree")
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"JoosepAlviste/nvim-ts-context-commentstring",
			"windwp/nvim-ts-autotag",
		},
		config = function()
			require("plugin-config.nvim-treesitter")
		end,
	},

	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {},
	},

	-- comment
	{
		"numToStr/Comment.nvim",
		event = "VeryLazy",
		dependencies = {
			"JoosepAlviste/nvim-ts-context-commentstring",
		},
		config = function()
			require("plugin-config.comment")
		end,
	},

	-- flash
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		opts = {},
		keys = keys.flash,
	},

	-- lualine
	{
		"nvim-lualine/lualine.nvim",
		dependencies = "nvim-tree/nvim-web-devicons",
		lazy = false,
		config = function()
			require("plugin-config.lualine")
		end,
	},

	-- bufferline
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = "nvim-tree/nvim-web-devicons",
		lazy = false,
		config = function()
			require("plugin-config.bufferline")
		end,
	},

	-- git
	{
		"lewis6991/gitsigns.nvim",
		event = "VeryLazy",
		config = function()
			require("plugin-config.gitsigns")
		end,
	},

	-- lsp
	{
		"williamboman/mason.nvim",
		build = ":MasonUpdate", -- :MasonUpdate updates registry contents
		keys = keys.mason,
	},
	"williamboman/mason-lspconfig.nvim",
	"neovim/nvim-lspconfig",
	"folke/neoconf.nvim",

	-- lspsaga
	{
		"glepnir/lspsaga.nvim",
		event = "LspAttach",
		dependencies = {
			{ "nvim-tree/nvim-web-devicons" },
			--Please make sure you install markdown and markdown_inline parser
			{ "nvim-treesitter/nvim-treesitter" },
		},
		keys = keys.lspsaga,
		config = function()
			require("lsp.lspsaga")
		end,
	},

	-- cmp
	-- source
	"hrsh7th/cmp-nvim-lsp",
	"hrsh7th/cmp-buffer",
	"hrsh7th/cmp-path",
	"hrsh7th/cmp-cmdline",
	"saadparwaiz1/cmp_luasnip",
	-- snip
	{
		"L3MON4D3/LuaSnip",
		dependencies = { "rafamadriz/friendly-snippets" },
	},
	-- main
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"saadparwaiz1/cmp_luasnip",
		},
	},
	{
		"onsails/lspkind.nvim",
	},

	-- null-ls
	{
		"jose-elias-alvarez/null-ls.nvim",
		event = "LspAttach",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			require("lsp.null-ls")
		end,
	},

	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		keys = keys.trouble,
		opts = require("plugin-config.trouble"),
	},

	-- ai
	-- {
	-- 	"Exafunction/codeium.vim",
	-- 	enabled = false,
	-- 	event = "VeryLazy",
	-- 	keys = keys.codeium,
	-- 	config = function()
	-- 		require("plugin-config.codeium")
	-- 	end,
	-- },
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			require("plugin-config.copilot")
		end,
	},
	{
		"zbirenbaum/copilot-cmp",
		config = function()
			require("copilot_cmp").setup()
		end,
	},

	{
		"jonahgoldwastaken/copilot-status.nvim",
		dependencies = { "zbirenbaum/copilot.lua" },
		lazy = true,
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

	{
		"kdheepak/lazygit.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		keys = keys.lazygit,
		opts = {},
	},

	-- 现代化折叠
	{
		"kevinhwang91/nvim-ufo",
		event = "VeryLazy",
		dependencies = {
			"kevinhwang91/promise-async",
		},
		keys = keys.nvim_ufo,
		config = function()
			require("plugin-config.nvim-ufo")
		end,
	},

	-- 颜色高亮
	{
		"brenoprata10/nvim-highlight-colors",
		event = "VeryLazy",
		keys = keys.color_highlight,
		opts = {
			render = "background", -- or 'foreground' or 'first_column'
			enable_named_colors = true,
			enable_tailwind = true,
		},
	},
}, {
	defaults = {
		lazy = true,
	},
})
