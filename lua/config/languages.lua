local project = require("config.project")
local registry = require("utils.language_registry")

local javascript_filetypes = {
  "javascript",
  "javascriptreact",
  "typescript",
  "typescriptreact",
}

---为 Astro LSP 优先选择项目 TypeScript SDK，并回退到 Mason 版本。
---@param _ lsp.InitializeParams
---@param config vim.lsp.ClientConfig
local function set_typescript_sdk(_, config)
  local tsdk = require("lspconfig.util").get_typescript_server_path(config.root_dir)
  if not tsdk or tsdk == "" then
    tsdk = vim.fn.stdpath("data")
      .. "/mason/packages/vtsls/node_modules/@vtsls/language-server/node_modules/typescript/lib"
  end
  config.init_options = config.init_options or {}
  config.init_options.typescript = config.init_options.typescript or {}
  config.init_options.typescript.tsdk = tsdk
end

local emmet_filetypes = {
  "html",
  "javascript",
  "javascriptreact",
  "typescript",
  "typescriptreact",
  "vue",
  "astro",
}

local deno_formatters = {
  html = { "deno_fmt" },
  javascript = { "deno_fmt" },
  javascriptreact = { "deno_fmt" },
  typescript = { "deno_fmt" },
  typescriptreact = { "deno_fmt" },
  vue = { "deno_fmt" },
  astro = { "deno_fmt" },
  json = { "deno_fmt" },
  jsonc = { "deno_fmt" },
  markdown = { "deno_fmt" },
  yaml = { "deno_fmt" },
  css = { "deno_fmt" },
  scss = { "deno_fmt" },
  less = { "deno_fmt" },
}

local deno_linters = {
  javascript = { "deno" },
  javascriptreact = { "deno" },
  typescript = { "deno" },
  typescriptreact = { "deno" },
  vue = {},
  astro = {},
  json = {},
  jsonc = {},
  markdown = {},
  yaml = {},
  css = {},
  scss = {},
  less = {},
}

local node_formatters = {
  html = { "prettier" },
  javascript = { "prettier" },
  javascriptreact = { "prettier" },
  typescript = { "prettier" },
  typescriptreact = { "prettier" },
  vue = { "prettier" },
  astro = { "prettier" },
  json = { "prettier" },
  jsonc = { "prettier" },
  markdown = { "prettier" },
  yaml = { "prettier" },
  css = { "prettier" },
  scss = { "prettier" },
  less = { "prettier" },
}

local node_linters = {
  javascript = { "eslint" },
  javascriptreact = { "eslint" },
  typescript = { "eslint" },
  typescriptreact = { "eslint" },
  vue = { "eslint" },
  astro = { "eslint" },
  json = {},
  jsonc = {},
  markdown = {},
  yaml = {},
  css = {},
  scss = {},
  less = {},
}

---@type table<string, LanguageDefinitionSpec>
local languages = {
  lua = {
    filetypes = { "lua" },
    treesitter = { "lua" },
    toolchain = false,
    projects = {},
    tools = {
      mason = { "stylua" },
      formatters = { lua = { "stylua" } },
      linters = {},
    },
    lsp = {
      name = "lua_ls",
      mason = true,
      root = false,
      config = {
        filetypes = { "lua" },
        workspace_required = false,
        root_markers = { ".luarc.json", ".luarc.jsonc", ".stylua.toml", "stylua.toml", ".git" },
        settings = {
          Lua = {
            completion = { callSnippet = "Replace" },
            diagnostics = { globals = { "vim", "Snacks" } },
            hint = { enable = true },
            workspace = {
              checkThirdParty = false,
              library = { vim.env.VIMRUNTIME },
            },
          },
        },
      },
    },
  },

  go = {
    filetypes = { "go", "gomod", "gowork", "gotmpl" },
    treesitter = { "go", "gomod", "gosum", "gowork" },
    toolchain = false,
    projects = {},
    tools = {
      mason = { "golangci-lint" },
      formatters = { go = { "gofmt" } },
      linters = { go = { "golangcilint" } },
    },
    lsp = {
      name = "gopls",
      mason = true,
      root = false,
      config = {
        filetypes = { "go", "gomod", "gowork", "gotmpl" },
        workspace_required = false,
      },
    },
  },

  rust = {
    filetypes = { "rust" },
    treesitter = { "rust" },
    toolchain = false,
    projects = {},
    tools = {
      mason = {},
      formatters = { rust = { "rustfmt" } },
      linters = {},
    },
    lsp = {
      name = "rust_analyzer",
      mason = true,
      root = false,
      config = {
        filetypes = { "rust" },
        workspace_required = false,
        settings = {
          ["rust-analyzer"] = {
            check = { command = "clippy" },
          },
        },
      },
    },
  },

  python = {
    filetypes = { "python" },
    treesitter = { "python" },
    toolchain = false,
    projects = {},
    tools = {
      mason = { "ruff" },
      formatters = { python = { "ruff_format" } },
      linters = { python = { "ruff" } },
    },
    lsp = {
      name = "basedpyright",
      mason = true,
      root = false,
      config = {
        filetypes = { "python" },
        workspace_required = false,
      },
    },
  },

  html = {
    filetypes = { "html" },
    treesitter = { "html" },
    toolchain = "typescript",
    projects = {},
    tools = false,
    lsp = {
      {
        name = "html",
        mason = true,
        root = false,
        config = {
          filetypes = { "html" },
          workspace_required = false,
        },
      },
      {
        name = "emmet_language_server",
        mason = true,
        root = false,
        config = {
          filetypes = emmet_filetypes,
          workspace_required = false,
          init_options = {
            includeLanguages = {
              javascript = "javascriptreact",
              typescript = "typescriptreact",
            },
            showAbbreviationSuggestions = true,
            showExpandedAbbreviation = "always",
            showSuggestionsAsSnippets = true,
          },
        },
      },
      {
        name = "tailwindcss",
        mason = true,
        root = project.tailwind_root,
        config = {},
      },
      {
        name = "unocss",
        mason = true,
        root = false,
        config = {},
      },
    },
  },

  typescript = {
    filetypes = javascript_filetypes,
    treesitter = { "javascript", "typescript", "tsx" },
    lsp = false,
    toolchain = false,
    tools = {
      mason = { "prettier" },
      formatters = node_formatters,
      linters = {},
    },
    projects = {
      deno = {
        priority = 100,
        root = project.deno_root,
        tools = {
          mason = { "deno" },
          formatters = deno_formatters,
          linters = deno_linters,
        },
        lsp = {
          name = "denols",
          mason = true,
          root = project.deno_root_or_script_dir,
          config = {
            filetypes = javascript_filetypes,
            workspace_required = true,
            init_options = {
              enable = true,
              lint = false,
              unstable = true,
            },
          },
        },
      },
      node = {
        priority = 50,
        root = project.node_root,
        tools = {
          mason = { "prettier" },
          formatters = node_formatters,
          linters = node_linters,
        },
        lsp = {
          name = "vtsls",
          mason = true,
          root = project.typescript_root,
          config = {
            filetypes = vim.list_extend(vim.deepcopy(javascript_filetypes), { "vue" }),
            workspace_required = true,
            settings = {
              vtsls = {
                tsserver = {
                  globalPlugins = {
                    {
                      name = "@vue/typescript-plugin",
                      location = vim.fn.stdpath("data")
                        .. "/mason/packages/vue-language-server/node_modules/@vue/language-server",
                      languages = { "vue" },
                      configNamespace = "typescript",
                    },
                  },
                },
              },
            },
          },
        },
      },
    },
  },

  vue = {
    filetypes = { "vue" },
    treesitter = { "vue" },
    toolchain = "typescript",
    projects = {},
    tools = false,
    lsp = {
      name = "vue_ls",
      mason = true,
      root = project.framework_root,
      config = {
        filetypes = { "vue" },
        workspace_required = true,
      },
    },
  },

  astro = {
    filetypes = { "astro" },
    treesitter = { "astro" },
    toolchain = "typescript",
    projects = {},
    tools = false,
    lsp = {
      name = "astro",
      mason = true,
      root = project.framework_root,
      config = {
        filetypes = { "astro" },
        workspace_required = true,
        before_init = set_typescript_sdk,
      },
    },
  },

  styles = {
    filetypes = { "css", "scss", "less" },
    treesitter = { "css", "scss" },
    lsp = {
      name = "cssls",
      mason = true,
      root = false,
      config = {
        filetypes = { "css", "scss", "less" },
        workspace_required = false,
      },
    },
    toolchain = "typescript",
    projects = {},
    tools = false,
  },

  json = {
    filetypes = { "json", "jsonc" },
    treesitter = { "json" },
    lsp = false,
    toolchain = "typescript",
    projects = {},
    tools = false,
  },

  yaml = {
    filetypes = { "yaml" },
    treesitter = { "yaml" },
    lsp = false,
    toolchain = "typescript",
    projects = {},
    tools = false,
  },

  markdown = {
    filetypes = { "markdown" },
    treesitter = { "markdown", "markdown_inline" },
    lsp = false,
    toolchain = "typescript",
    projects = {},
    tools = false,
  },
}

return registry.setup(languages)
