require('lualine').setup({
  options = {
    -- 指定皮肤
    -- https://github.com/nvim-lualine/lualine.nvim/blob/master/THEMES.md
    theme = "auto",
    -- 分割线
    component_separators = {
      left = "|",
      right = "|",
    },
    globalstatus = true,
  },
  extensions = { "nvim-tree" },
  sections = {
    lualine_x = {
      "filesize",
      {
        "fileformat",
        symbols = {
          unix = "LF",
          dos = "CRLF",
          mac = "CR",
        },
      },
      "encoding",
      "filetype",
    },
  },
})
