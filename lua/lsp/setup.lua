local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
local lspconfig = require("lspconfig")
local neoconf = require("neoconf")

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

local lsp = {
	"lua_ls",
	"bashls",
	"pyright",
	"rust_analyzer",
	"taplo",
	"jsonls",
	"yamlls",
	-- nix
	-- "rnix",
	--markdown
	"marksman",

	-- web
	"emmet_language_server",
	"cssls",
	"unocss",
	"html",
	"tsserver",
	"volar",
	"tailwindcss",
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

-- 禁用冲突 lsp
local disable_clash_lsp = function(server_name, default_lsp, fallback_lsp)
	if server_name ~= default_lsp and server_name ~= fallback_lsp then
		return false
	end

	local fallback_is_enabled = neoconf.get(fallback_lsp .. ".enable")

	-- 备用 lsp 启用时禁用默认 lsp
	if fallback_is_enabled then
		if server_name == default_lsp then
			return true
		end
	-- 否则禁用备用 lsp
	else
		if server_name == fallback_lsp then
			return true
		end
	end

	return false
end

mason_lspconfig.setup_handlers({
	function(server_name)
		if disable_clash_lsp(server_name, "tsserver", "volar") then
			return
		end

		if disable_clash_lsp(server_name, "unocss", "tailwindcss") then
			return
		end

		-- setup lspconfig
		local config = get_config(server_name)
		lspconfig[server_name].setup(config)
	end,
})
