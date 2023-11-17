return {
	{
		"hrsh7th/nvim-cmp",
		event = { "InsertEnter", "CmdlineEnter" },
		dependencies = {
			-- source
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"FelipeLema/cmp-async-path",
			"hrsh7th/cmp-cmdline",
			"saadparwaiz1/cmp_luasnip",
			-- snippet
			"L3MON4D3/LuaSnip",
			-- This tiny plugin adds vscode-like pictograms to neovim built-in lsp
			"onsails/lspkind.nvim",
      "zbirenbaum/copilot-cmp",
      "windwp/nvim-autopairs",
		},
		config = function()
			local lspkind = require("lspkind")
			local luasnip = require("luasnip")
			local cmp = require("cmp")

			local has_words_before = function()
				unpack = unpack or table.unpack
				local line, col = unpack(vim.api.nvim_win_get_cursor(0))
				return col ~= 0
					and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
			end

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},

				mapping = cmp.mapping.preset.insert({
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),

					-- select next
					["<C-j>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif has_words_before() then
							cmp.complete()
						else
							fallback()
						end
					end, { "i", "s" }),

					-- select prev
					["<C-k>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						else
							fallback()
						end
					end, { "i", "s" }),

					-- snippet
					["<Tab>"] = cmp.mapping(function(fallback)
						-- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
						-- they way you will only jump inside the snippet region
						if luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),

					["<S-Tab>"] = cmp.mapping(function(fallback)
						if luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),

				sources = cmp.config.sources({
					-- Copilot Source
					{ name = "copilot", group_index = 2 },
					{ name = "nvim_lsp", trigger_characters = { "-", ".", "::" } },
					{ name = "luasnip" }, -- For luasnip users.
				}, {
					{ name = "buffer" },
					{
						name = "async_path",
						option = {
							trailing_slash = true,
						},
					},
				}),

				sorting = {
					priority_weight = 2,
					comparators = {
						-- 提高copilot条目优先级
						require("copilot_cmp.comparators").prioritize,

						-- Below is the default comparitor list and order for nvim-cmp
						cmp.config.compare.offset,
						-- cmp.config.compare.scopes, --this is commented in nvim-cmp too
						cmp.config.compare.exact,
						cmp.config.compare.score,
						cmp.config.compare.recently_used,
						cmp.config.compare.locality,
						cmp.config.compare.kind,
						cmp.config.compare.sort_text,
						cmp.config.compare.length,
						cmp.config.compare.order,
					},
				},

				formatting = {
					format = lspkind.cmp_format({
						mode = "symbol",
						max_width = 50,
						ellipsis_char = "...",
						symbol_map = { Copilot = "" },
					}),
				},
			})

			-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
			cmp.setup.cmdline({ "/", "?" }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			})

			-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{
						name = "async_path",
						option = {
							trailing_slash = true,
						},
					},
				}, {
					{ name = "cmdline" },
				}),
			})

			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
		end,
	},

	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			require("copilot").setup({
				panel = {
					enabled = false,
				},
				suggestion = {
					enabled = false,
				},
			})
		end,
	},

	{
		"zbirenbaum/copilot-cmp",
		config = function()
			require("copilot_cmp").setup()
		end,
	},

	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {},
	},

	{
		"L3MON4D3/LuaSnip",
		dependencies = { "rafamadriz/friendly-snippets" },
		keys = {
			{
				"<leader>se",
				function()
					require("luasnip.loaders").edit_snippet_files()
				end,
				desc = "edit snippet files",
			},
		},
		config = function()
			local config_path = vim.fn.stdpath("config")

			require("luasnip.loaders.from_vscode").lazy_load()
			require("luasnip.loaders.from_vscode").lazy_load({
				paths = config_path .. "/snippets",
			})
		end,
	},
}
