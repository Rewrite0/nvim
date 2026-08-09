local project = require("config.project")
local registry = require("utils.language_registry")

local javascript_filetypes = {
  "javascript",
  "javascriptreact",
  "typescript",
  "typescriptreact",
}

local deno_formatters = {
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
}

local node_formatters = {
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
      name = "pyright",
      mason = true,
      root = false,
      config = {
        filetypes = { "python" },
      },
    },
  },

  typescript = {
    filetypes = javascript_filetypes,
    treesitter = { "javascript", "typescript", "tsx" },
    lsp = false,
    toolchain = false,
    tools = false,
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
          root = false,
          config = {
            filetypes = javascript_filetypes,
            single_file_support = false,
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
          name = "ts_ls",
          mason = true,
          root = false,
          config = {
            filetypes = vim.list_extend(vim.deepcopy(javascript_filetypes), { "vue" }),
            single_file_support = false,
            init_options = {
              plugins = {
                {
                  name = "@vue/typescript-plugin",
                  location = vim.fn.stdpath("data")
                    .. "/mason/packages/vue-language-server/node_modules/@vue/language-server",
                  languages = { "javascript", "typescript", "vue" },
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
      root = project.node_root,
      config = {
        filetypes = { "vue" },
        single_file_support = false,
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
      root = project.node_root,
      config = {
        filetypes = { "astro" },
        single_file_support = false,
      },
    },
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
