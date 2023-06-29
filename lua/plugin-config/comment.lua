local comment = require('Comment')

local keys = {
  line = '<C-/>',
  block = '<A-S-a>'
}

comment.setup({
  mappings = {
    extra = false
  },

  toggler = keys,

  opleader = keys,

  pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
})
