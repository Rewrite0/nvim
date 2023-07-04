local comment = require("Comment")

local keys = {
	line = "<leader>cl",
	block = "<leader>cb",
}

comment.setup({
	mappings = {
		extra = false,
	},

	---LHS of toggle mappings in NORMAL mode
	toggler = keys,

	---LHS of operator-pending mappings in NORMAL and VISUAL mode
	opleader = keys,

	pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
})
