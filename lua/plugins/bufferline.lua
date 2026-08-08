return {
  {
    "akinsho/bufferline.nvim",
    version = "*",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        mode = "buffers",
        diagnostics = "nvim_lsp",
        always_show_bufferline = true,
        show_buffer_close_icons = true,
        show_close_icon = false,
        separator_style = "slant",
        offsets = {},
      },
    },
  },
}
