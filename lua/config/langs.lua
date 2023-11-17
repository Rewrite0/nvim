local utils = require("config.utils")

local servers = {
	"lua_ls",
	"bashls",
	"pyright",
	"rust_analyzer",
	"taplo",
	"jsonls",
	"yamlls",
	"dockerls",
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

local web_tools = {
	lint = "eslint_d",
	format = "prettierd",
}

local langs = {
	javascript = web_tools,
	typescript = web_tools,
	javascriptreact = web_tools,
	typescriptreact = web_tools,
	vue = web_tools,
	css = {
		lint = "stylelint",
		format = "prettierd",
	},
	sass = {
		lint = "stylelint",
		format = "prettierd",
	},
	html = {
		format = "prettierd",
	},
	json = {
		format = "prettierd",
	},
	yaml = {
		format = "prettierd",
	},
	lua = {
		lint = "luacheck",
		format = "stylua",
	},
	python = {
		lint = "ruff",
		format = "black",
	},
	bash = {
		lint = "shellharden",
		format = "shellharden",
	},
}

local formatters_by_ft = {}
local linters_by_ft = {}
local lint_and_format = {}

for ft, tools in pairs(langs) do
	formatters_by_ft[ft] = { tools.format }
	table.insert(lint_and_format, tools.format)

	if tools.lint then
		linters_by_ft[ft] = { tools.lint }
		table.insert(lint_and_format, tools.lint)
	end
end

return {
	servers = servers,
	install_list = utils.table_unique(lint_and_format),
	formatters_by_ft = formatters_by_ft,
	linters_by_ft = linters_by_ft,
}
