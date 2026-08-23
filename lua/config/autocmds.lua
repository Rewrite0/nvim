local group = vim.api.nvim_create_augroup("user_config", { clear = true })
local eslint_group = vim.api.nvim_create_augroup("antfu_eslint_format", { clear = true })
local unnecessary_namespaces = {}

vim.diagnostic.handlers.unnecessary = {
  show = function(namespace, bufnr, diagnostics)
    if not vim.api.nvim_buf_is_valid(bufnr) then
      return
    end

    local highlight_namespace = unnecessary_namespaces[namespace]
    if not highlight_namespace then
      highlight_namespace = vim.api.nvim_create_namespace("user.diagnostic.unnecessary." .. namespace)
      unnecessary_namespaces[namespace] = highlight_namespace
    end
    vim.api.nvim_buf_clear_namespace(bufnr, highlight_namespace, 0, -1)

    for _, diagnostic in ipairs(diagnostics) do
      if diagnostic._tags and diagnostic._tags.unnecessary then
        local line = vim.api.nvim_buf_get_lines(bufnr, diagnostic.lnum, diagnostic.lnum + 1, true)[1]
        if line then
          vim.hl.range(
            bufnr,
            highlight_namespace,
            "DiagnosticUnnecessary",
            { diagnostic.lnum, math.min(diagnostic.col, math.max(#line - 1, 0)) },
            { diagnostic.end_lnum, diagnostic.end_col },
            { priority = vim.hl.priorities.diagnostics }
          )
        end
      end
    end
  end,
  hide = function(namespace, bufnr)
    local highlight_namespace = unnecessary_namespaces[namespace]
    if highlight_namespace and vim.api.nvim_buf_is_valid(bufnr) then
      vim.api.nvim_buf_clear_namespace(bufnr, highlight_namespace, 0, -1)
    end
  end,
}

vim.api.nvim_create_autocmd("TextYankPost", {
  group = group,
  desc = "复制时高亮文本",
  -- 短暂高亮刚复制的文本，提供操作反馈。
  callback = function()
    vim.hl.on_yank()
  end,
})

-- 在不覆盖补全插件 `<CR>` 映射的前提下切断插入撤销块。
vim.on_key(function(key)
  if key == "\r" and vim.fn.mode():sub(1, 1) == "i" then
    vim.api.nvim_feedkeys(vim.keycode("<C-g>u"), "n", false)
  end
end, vim.api.nvim_create_namespace("user.undo_break"))

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
  unnecessary = true,
  signs = true,
  virtual_text = { spacing = 2, source = "if_many" },
})
