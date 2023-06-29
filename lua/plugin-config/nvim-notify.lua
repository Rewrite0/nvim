local nvim_notify = require('notify')

nvim_notify.setup({
  stages = "fade",
  timeout = 3000
})

vim.notify = nvim_notify
