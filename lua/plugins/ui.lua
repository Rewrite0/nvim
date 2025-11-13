return {
	-- file tree
	{
		"nvim-tree/nvim-tree.lua",
		lazy = false,
		dependencies = "nvim-tree/nvim-web-devicons",
		keys = {
			{
				"<leader>e",
				":NvimTreeToggle<CR>",
				desc = "toggle nvim tree",
			},
		},
		opts = {},
		init = function()
			vim.g.loaded_netrw = 1
			vim.g.loaded_netrwPlugin = 1

			-- 开启目录时打开 tree
			local function open_nvim_tree(data)
				-- buffer is a directory
				local directory = vim.fn.isdirectory(data.file) == 1

				if not directory then
					return
				end

				-- change to the directory
				vim.cmd.cd(data.file)

				-- open the tree
				require("nvim-tree.api").tree.open()
			end

			vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })
		end,
	},

	-- bufferline
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = "nvim-tree/nvim-web-devicons",
		lazy = false,
		opts = {},
	},

	-- 现代化折叠
	{
		"kevinhwang91/nvim-ufo",
		event = "VeryLazy",
		dependencies = {
			"kevinhwang91/promise-async",
		},
		keys = {
			{
				"zC",
				function()
					require("ufo").closeAllFolds()
				end,
				desc = "close all folds",
			},
			{
				"zO",
				function()
					require("ufo").openAllFolds()
				end,
				desc = "open all folds",
			},
		},
		config = function()
			local handler = function(virtText, lnum, endLnum, width, truncate)
				local newVirtText = {}
				local suffix = (" 󰁂 %d "):format(endLnum - lnum)
				local sufWidth = vim.fn.strdisplaywidth(suffix)
				local targetWidth = width - sufWidth
				local curWidth = 0
				for _, chunk in ipairs(virtText) do
					local chunkText = chunk[1]
					local chunkWidth = vim.fn.strdisplaywidth(chunkText)
					if targetWidth > curWidth + chunkWidth then
						table.insert(newVirtText, chunk)
					else
						chunkText = truncate(chunkText, targetWidth - curWidth)
						local hlGroup = chunk[2]
						table.insert(newVirtText, { chunkText, hlGroup })
						chunkWidth = vim.fn.strdisplaywidth(chunkText)
						-- str width returned from truncate() may less than 2nd argument, need padding
						if curWidth + chunkWidth < targetWidth then
							suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
						end
						break
					end
					curWidth = curWidth + chunkWidth
				end
				table.insert(newVirtText, { suffix, "MoreMsg" })
				return newVirtText
			end

			require("ufo").setup({
				provider_selector = function(bufnr, filetype, buftype)
					return { "treesitter", "indent" }
				end,
				fold_virt_text_handler = handler,
			})
		end,
	},

	-- 颜色值高亮
	{
		"brenoprata10/nvim-highlight-colors",
		event = "VeryLazy",
		keys = {
			{
				"<leader>cc",
				function()
					require("nvim-highlight-colors").toggle()
				end,
				desc = "toggle color highlight",
			},
		},
		opts = {
			render = "background", -- or 'foreground' or 'first_column'
			enable_named_colors = true,
			enable_tailwind = true,
		},
	},

	-- which key
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		opts = {},
	},
}
