local group = vim.api.nvim_create_augroup("user_config", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
  group = group,
  desc = "复制时高亮文本",
  -- 短暂高亮刚复制的文本，提供操作反馈。
  callback = function()
    vim.hl.on_yank()
  end,
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = group,
  desc = "设置 LSP 快捷键",
  -- 为刚连接 LSP 的缓冲区注册局部快捷键。
  callback = function(event)
    ---注册当前缓冲区的普通模式快捷键。
    ---@param lhs string
    ---@param rhs string|function
    ---@param desc string
    local map = function(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, { buffer = event.buf, desc = desc })
    end

    map("gd", vim.lsp.buf.definition, "跳转到定义")
    map("gr", vim.lsp.buf.references, "查找引用")
    map("gD", vim.lsp.buf.declaration, "跳转到声明")
    map("<leader>cr", vim.lsp.buf.rename, "重命名")
    map("<leader>ca", vim.lsp.buf.code_action, "代码操作")
    -- 跳转到上一个诊断并显示详情。
    map("[d", function()
      vim.diagnostic.jump({ count = -1, float = true })
    end, "上一个诊断")
    -- 跳转到下一个诊断并显示详情。
    map("]d", function()
      vim.diagnostic.jump({ count = 1, float = true })
    end, "下一个诊断")
  end,
})

vim.diagnostic.config({
  severity_sort = true,
  float = { border = "rounded", source = "if_many" },
  underline = { severity = vim.diagnostic.severity.ERROR },
  signs = true,
  virtual_text = { spacing = 2, source = "if_many" },
})
