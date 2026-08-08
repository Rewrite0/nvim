local languages = require("config.languages")

return {
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    opts = { ui = { border = "rounded" } },
  },
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {
      ensure_installed = languages.mason_servers(),
      automatic_enable = false,
    },
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "saghen/blink.cmp" },
    -- 为所有服务补充 blink.cmp 能力，并启用声明的 LSP 配置。
    config = function()
      vim.lsp.config("*", {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
      })

      local servers = {}
      for name, config in pairs(languages.lsp_configs()) do
        vim.lsp.config(name, config)
        servers[#servers + 1] = name
      end
      table.sort(servers)
      vim.lsp.enable(servers)
    end,
  },
}
