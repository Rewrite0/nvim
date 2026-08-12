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
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      ensure_installed = languages.mason_tools(),
    },
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    cmd = "LspRestart",
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

      vim.api.nvim_create_user_command("LspRestart", function(command)
        local names = {}
        if command.args ~= "" then
          names[1] = command.args
        else
          local seen = {}
          for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
            if not seen[client.name] then
              seen[client.name] = true
              names[#names + 1] = client.name
            end
          end
          table.sort(names)
        end

        if #names == 0 then
          vim.notify("当前 Buffer 没有已附加的 LSP", vim.log.levels.WARN)
          return
        end

        vim.lsp.enable(names, false)
        vim.lsp.enable(names)
        vim.notify("已重启 LSP: " .. table.concat(names, ", "))
      end, {
        nargs = "?",
        desc = "重启指定 LSP，未指定时重启当前 Buffer 的所有 LSP",
        complete = function()
          return servers
        end,
      })
    end,
  },
}
