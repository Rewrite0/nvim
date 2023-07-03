local merge_table = require("utils").merge_table

local capabilities = require("cmp_nvim_lsp").default_capabilities()

local get_config = function(name)
	local default_config = {
		capabilities = capabilities,
	}

	local ok, config = pcall(require, "lsp.config." .. name)

	if not ok then
		return default_config
	end

	if config ~= nil and type(config) == "table" then
		return merge_table(default_config, config)
	end

	return default_config
end

local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
local lspconfig = require("lspconfig")
local neoconf = require("neoconf")

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

neoconf.setup({
	local_settings = ".neoconf.json",
	global_settings = "neoconf.json",
})

mason_lspconfig.setup({
	ensure_installed = lsp,
})

-- 获取 volar 是否启用
local volar_enabled = neoconf.get("volar.enable")

mason_lspconfig.setup_handlers({
	function(server_name)
		if volar_enabled then
			-- volar 启用时禁用 tsserver
			if server_name == "tsserver" then
				return
			end
		else
			-- volar 默认禁用
			if server_name == "volar" then
				return
			end
		end

		-- setup lspconfig
		local config = get_config(server_name)
		lspconfig[server_name].setup(config)
	end,
})
