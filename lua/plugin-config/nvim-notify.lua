local nvim_notify = require("notify")

nvim_notify.setup({
	stages = "fade_in_slide_out",
	timeout = 2000,
	render = "default",
})

vim.notify = nvim_notify
