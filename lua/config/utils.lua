local cmd = vim.cmd
local fn = vim.fn

return {
	-- 按键映射
	map = function(mode, lhs, rhs, opts)
		local options = { noremap = true, silent = true }
		if opts then
			options = vim.tbl_extend("force", options, opts)
		end
		-- vim.api.nvim_set_keymap(mode, lhs, rhs, options)
		vim.keymap.set(mode, lhs, rhs, options)
	end,

	-- 合并俩个 table
	merge_table = function(a, b)
		return vim.tbl_extend("force", a, b)
	end,

	-- 关闭当前 buffer
	close_buffer = function()
		-- 获取当前所有的buffer列表
		local buflisted = fn.getbufinfo({ buflisted = 1 })
		local cur_winnr, cur_bufnr = fn.winnr(), fn.bufnr()
		if #buflisted < 2 then
			cmd("confirm qall")
			return
		end
		for _, winid in ipairs(fn.getbufinfo(cur_bufnr)[1].windows) do
			cmd(string.format("%d wincmd w", fn.win_id2win(winid)))
			cmd(cur_bufnr == buflisted[#buflisted].bufnr and "bp" or "bn")
		end
		cmd(string.format("%d wincmd w", cur_winnr))
		local is_terminal = fn.getbufvar(cur_bufnr, "&buftype") == "terminal"
		cmd(is_terminal and "bd! #" or "silent! confirm bd #")
	end,

	-- lua table 去重
	table_unique = function(t)
		local hash = {}
		local res = {}
		for _, v in ipairs(t) do
			if not hash[v] then
				hash[v] = true
				table.insert(res, v)
			end
		end
		return res
	end,
}
