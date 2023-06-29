local try_require = require("utils").try_require
local merge_table = require("utils").merge_table

local capabilities = require("cmp_nvim_lsp").default_capabilities()

local get_config = function(name)
	local default_config = {
		capabilities = capabilities,
	}

	local config = try_require("lsp.cofig." .. name)

	if config ~= nil and type(config) == "table" then
		return merge_table(default_config, config)
	end

	return default_config
end

local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
local lspconfig = require("lspconfig")

local lsp = {
	"lua_ls",
	"bashls",
	"pyright",
	"rust_analyzer",
	"taplo",
	"jsonls",
	"yamlls",
	-- nix
	"rnix",
	--markdown
	"marksman",

	-- web
	"emmet_ls",
	"cssls",
	"unocss",
	"html",
	"tsserver",
	"volar",
}

----------------------------
-- setup
----------------------------

mason.setup({
	ui = {
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗",
		},
	},
})

mason_lspconfig.setup({
	ensure_installed = lsp,
})

-- setup lsp config
for _, name in pairs(lsp) do
	local config = get_config(name)

	lspconfig[name].setup(config)
end