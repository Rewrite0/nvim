local comment = require("Comment")

comment.setup({
	mappings = {
		extra = false,
	},

	pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
})
