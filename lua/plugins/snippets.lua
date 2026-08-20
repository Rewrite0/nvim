local snippet_dir = vim.fn.stdpath("config") .. "/snippets"

return {
  {
    "nvim-mini/mini.snippets",
    version = false,
    event = "InsertEnter",
    dependencies = { "rafamadriz/friendly-snippets" },
    config = function()
      local mini_snippets = require("mini.snippets")
      local gen_loader = mini_snippets.gen_loader

      local function load_custom_snippets(context)
        local package_path = snippet_dir .. "/package.json"
        local ok, package = pcall(function()
          return vim.json.decode(table.concat(vim.fn.readfile(package_path), "\n"))
        end)
        if not ok then
          vim.notify("无法读取自定义代码片段配置: " .. package_path, vim.log.levels.WARN)
          return {}
        end

        local loaded = {}
        for _, spec in ipairs(vim.tbl_get(package, "contributes", "snippets") or {}) do
          local languages = type(spec.language) == "table" and spec.language or { spec.language }
          if vim.list_contains(languages, context.lang) then
            local path = vim.fs.normalize(vim.fs.joinpath(snippet_dir, spec.path))
            table.insert(loaded, mini_snippets.read_file(path, { cache = false, silent = true }))
          end
        end
        return loaded
      end

      mini_snippets.setup({
        snippets = {
          gen_loader.from_lang(),
          load_custom_snippets,
        },
        mappings = {
          expand = "",
          jump_next = "",
          jump_prev = "",
          stop = "",
        },
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = "MiniSnippetsSessionJump",
        callback = function(args)
          if args.data.tabstop_to == "0" then
            mini_snippets.session.stop()
          end
        end,
        desc = "跳到最终占位符后结束代码片段会话",
      })
    end,
  },
  {
    "chrisgrieser/nvim-scissors",
    dependencies = {
      "nvim-mini/mini.snippets",
      "folke/snacks.nvim",
    },
    cmd = { "ScissorsAddNewSnippet", "ScissorsEditSnippet" },
    keys = {
      {
        "<leader>sa",
        function()
          require("scissors").addNewSnippet()
        end,
        mode = { "n", "x" },
        desc = "新增代码片段",
      },
      {
        "<leader>se",
        function()
          require("scissors").editSnippet()
        end,
        desc = "编辑代码片段",
      },
    },
    opts = {
      snippetDir = snippet_dir,
      snippetSelection = { picker = "snacks" },
    },
  },
}
