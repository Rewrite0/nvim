local null_ls = require("null-ls")

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

local lsp_formatting = function(bufnr)
	vim.lsp.buf.format({
		filter = function(client)
			-- apply whatever logic you want (in this example, we'll only use null-ls)
			return client.name == "null-ls"
		end,
		bufnr = bufnr,
	})
end

null_ls.setup({
	sources = {
		-- lua format
		null_ls.builtins.formatting.stylua,

		-- github actions
		null_ls.builtins.diagnostics.actionlint,

		-- shell
		null_ls.builtins.code_actions.shellcheck,
		null_ls.builtins.diagnostics.shellcheck,
		null_ls.builtins.formatting.shellharden,

		-- eslint
		null_ls.builtins.diagnostics.eslint_d,
		null_ls.builtins.code_actions.eslint_d,

		-- dockerfile linter
		null_ls.builtins.diagnostics.hadolint,

		-- prettier
		null_ls.builtins.formatting.prettierd,

		-- toml
		null_ls.builtins.formatting.taplo,

		-- python linter
		null_ls.builtins.diagnostics.ruff,
		null_ls.builtins.formatting.ruff,

		-- rust
		null_ls.builtins.formatting.rustfmt,
	},

	-- you can reuse a shared lspconfig on_attach callback here
	on_attach = function(client, bufnr)
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					lsp_formatting()
				end,
			})
		end
	end,
})
