local languages = require("config.languages")
local project = require("config.project")

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
        -- 保留 ESLint LSP 默认的 before_init，再追加 antfu 项目设置。
        if name == "eslint" and config.antfu_before_init then
          local antfu_before_init = config.antfu_before_init
          local base_config = vim.lsp.config[name]
          local default_before_init = base_config and base_config.before_init
          config.antfu_before_init = nil
          config.before_init = function(initialize_params, client_config)
            if default_before_init then
              default_before_init(initialize_params, client_config)
            end
            antfu_before_init(initialize_params, client_config)
          end

          local antfu_on_attach = function(_, bufnr)
            if not project.is_antfu_eslint(bufnr) then
              return
            end
            local command = vim.fn.exists(":LspEslintFixAll") == 2 and "LspEslintFixAll" or "EslintFixAll"
            if vim.fn.exists(":" .. command) == 2 then
              vim.api.nvim_clear_autocmds({ group = vim.api.nvim_create_augroup("antfu_eslint_format", { clear = false }), buffer = bufnr })
              vim.api.nvim_create_autocmd("BufWritePre", {
                group = "antfu_eslint_format",
                buffer = bufnr,
                desc = "使用 antfu ESLint 自动修复",
                command = command,
              })
            end
          end
          local default_on_attach = base_config and base_config.on_attach
          config.on_attach = function(client, bufnr)
            if default_on_attach then
              default_on_attach(client, bufnr)
            end
            antfu_on_attach(client, bufnr)
          end
        end
        vim.lsp.config(name, config)
        servers[#servers + 1] = name
      end
      table.sort(servers)
      vim.lsp.enable(servers)

      if vim.fn.exists(":LspRestart") == 2 then
        vim.api.nvim_del_user_command("LspRestart")
      end
      vim.api.nvim_create_user_command("LspRestart", function(command)
        local names = {}
        if command.args ~= "" then
          names[1] = command.args
        else
          local seen = {}
          for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
            if vim.lsp.is_enabled(client.name) and not seen[client.name] then
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

        require("utils.lsp").restart(names, function()
          vim.notify("已重启 LSP: " .. table.concat(names, ", "))
        end)
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
