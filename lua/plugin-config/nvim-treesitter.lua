require('nvim-treesitter.configs').setup {
  -- Install the parsers for the languages you want to comment in
  -- Here are the supported languages:
  ensure_installed = {
    'css', 'graphql', 'html', 'javascript',
    'lua', 'nix', 'php', 'python', 'scss',
    'svelte', 'tsx', 'typescript', 'vim',
    'vue', 'rust', 'toml', 'bash', 'comment',
    'jsdoc', 'json', 'jsonc', 'markdown',
    'markdown_inline'
  },

  -- 启用代码高亮模块
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
    disable = function(lang, bufnr) -- Disable in large C++ buffers
      return vim.api.nvim_buf_line_count(bufnr) > 10000
    end,
  },

  -- 启用代码缩进模块 (=)
  indent = {
    enable = true,
  },

  context_commentstring = {
    enable = true,
  },


  autotag = {
    enable = true
  }
}

-- 代码折叠
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
-- 默认不折叠
vim.opt.foldlevel = 99
vim.cmd("set nofoldenable")
