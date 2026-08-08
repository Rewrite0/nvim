# Neovim 配置

一套以 Lua 编写的 Neovim 配置，使用 `lazy.nvim` 管理插件，并通过统一语言注册表管理 LSP、Treesitter、formatter 和 linter。Leader 键为空格。

## 环境要求

- Neovim 0.11 或更高版本
- Git
- Nerd Font（用于图标显示）
- `ripgrep`（Snacks 全文搜索）
- `tree-sitter-cli >= 0.26.1`（安装 Treesitter parser）
- 可选：`lazygit`（终端 Git 界面）

格式化和 lint 命令需要在项目或系统 `PATH` 中可用，例如 Node 项目的 `prettier`、`eslint`，以及 Deno 项目的 `deno`。

## 安装

备份已有配置后，将本仓库放到 Neovim 配置目录：

```sh
git clone https://github.com/rewrite0/nvim ~/.config/nvim
nvim
```

首次启动时会自动安装 `lazy.nvim` 和声明的插件。使用 `:Lazy` 查看插件状态，使用 `:Mason` 查看 LSP 工具。

## 插件说明

| 插件 | 用途 |
| --- | --- |
| [folke/lazy.nvim](https://github.com/folke/lazy.nvim) | 插件安装、锁定和懒加载 |
| [catppuccin/nvim](https://github.com/catppuccin/nvim) | Catppuccin Mocha 配色 |
| [nvim-lualine/lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) | 全局状态栏 |
| [akinsho/bufferline.nvim](https://github.com/akinsho/bufferline.nvim) | Buffer 标签栏和 LSP 诊断标记 |
| [folke/snacks.nvim](https://github.com/folke/snacks.nvim) | 启动页、文件浏览、Picker、通知、终端和文本辅助功能 |
| [folke/which-key.nvim](https://github.com/folke/which-key.nvim) | Leader 快捷键提示 |
| [nvim-tree/nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons) | 文件和界面图标 |
| [neovim/nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | 基于 Neovim 原生 API 配置 LSP |
| [mason-org/mason.nvim](https://github.com/mason-org/mason.nvim) | 安装和管理 LSP 服务 |
| [mason-org/mason-lspconfig.nvim](https://github.com/mason-org/mason-lspconfig.nvim) | 将 Mason 与 LSP 配置连接起来 |
| [saghen/blink.cmp](https://github.com/Saghen/blink.cmp) | 插入模式与命令行实时补全 |
| [L3MON4D3/LuaSnip](https://github.com/L3MON4D3/LuaSnip) | 代码片段引擎 |
| [rafamadriz/friendly-snippets](https://github.com/rafamadriz/friendly-snippets) | 通用代码片段集合 |
| [nvim-treesitter/nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | 语法高亮与缩进 |
| [stevearc/conform.nvim](https://github.com/stevearc/conform.nvim) | 保存时和手动格式化 |
| [mfussenegger/nvim-lint](https://github.com/mfussenegger/nvim-lint) | 保存、进入 Buffer 和离开插入模式时 lint |
| [lewis6991/gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | Git 变更块、预览、暂存和还原 |

插件版本记录在 `lazy-lock.json` 中。

## 语言支持

语言配置集中在 `lua/config/languages.lua`，由 `lua/utils/language_registry.lua` 校验并提供给各插件。

| 语言/文件类型 | LSP | Formatter | Linter |
| --- | --- | --- | --- |
| Lua | `lua_ls` | 手动格式化时回退到 LSP | 无 |
| JavaScript / TypeScript / JSX / TSX（Node） | `ts_ls` | `prettier` | `eslint` |
| JavaScript / TypeScript / JSX / TSX（Deno） | `denols` | `deno fmt` | `deno lint` |
| Vue（Node） | `vue_ls` + `ts_ls` Vue 插件 | `prettier` | `eslint` |
| Astro（Node） | `astro` | `prettier` | `eslint` |
| Vue / Astro（Deno） | 无专用 LSP | `deno fmt` | 无 |
| JSON / JSONC / YAML / Markdown | 无 | 随 Node/Deno 项目选择 `prettier` 或 `deno fmt` | 无 |

Node 项目通过 `package.json`、`tsconfig.json` 或 `jsconfig.json` 识别；Deno 项目通过 `deno.json` 或 `deno.jsonc` 识别。Deno 优先级更高，同一路径下不会同时启动 `denols` 和 `ts_ls`。不属于 Node 或 Deno 项目的文件不会自动选择对应 formatter/linter。

Mason 自动安装 `lua_ls`、`denols`、`ts_ls`、`vue_ls` 和 Astro LSP。Mason 不负责本配置中的 `prettier`、`eslint` 或 `deno` 命令。

## 常用快捷键

### 基础与 Buffer

| 快捷键 | 功能 |
| --- | --- |
| `<leader>s` | 保存文件 |
| `<leader>w` | 关闭当前 Buffer 标签 |
| `<leader>q` | 关闭当前窗口 |
| `<leader>m` | 打开 Mason |
| `<leader>l` | 打开 Lazy |
| `<S-h>` / `<S-l>` | 上一个 / 下一个 Buffer 标签 |
| `<leader>bd` | 选择并关闭 Buffer 标签 |
| `<C-h/j/k/l>` | 聚焦相邻窗口 |
| `<Esc>` | 清除搜索高亮 |

### 查找与浏览

| 快捷键 | 功能 |
| --- | --- |
| `<leader>ff` | 查找文件 |
| `<leader>fg` | 全文搜索 |
| `<leader>fb` | 查找 Buffer |
| `<leader>fr` | 最近文件 |
| `<leader>e` | 文件浏览器 |

### LSP 与代码质量

以下 LSP 快捷键仅在服务附加到当前 Buffer 后生效。

| 快捷键 | 功能 |
| --- | --- |
| `gd` / `gD` | 跳转到定义 / 声明 |
| `gr` | 查找引用 |
| `K` | 悬浮文档 |
| `<leader>cr` | 重命名符号 |
| `<leader>ca` | 代码操作 |
| `[d` / `]d` | 上一个 / 下一个诊断 |
| `<leader>cf` | 格式化当前 Buffer 或选区 |
| `<leader>cl` | 手动运行当前项目的 linter |

### Git

| 快捷键 | 功能 |
| --- | --- |
| `]h` / `[h` | 下一个 / 上一个 Git 变更块 |
| `<leader>gs` | 暂存当前变更块 |
| `<leader>gr` | 还原当前变更块 |
| `<leader>gp` | 预览当前变更块 |
| `<leader>gg` | 打开 Lazygit |
| `<leader>gb` | 查看当前行 Git 追溯 |

## 目录结构

```text
init.lua                      # 配置入口与 lazy.nvim 引导
lua/config/                   # 选项、快捷键、自动命令和语言声明
lua/plugins/                  # 按功能拆分的插件规格
lua/utils/language_registry.lua # 语言注册表校验与派生逻辑
lazy-lock.json                # 插件版本锁文件
```

新增语言时修改 `lua/config/languages.lua`；新增通用注册表行为时修改 `lua/utils/language_registry.lua`；插件配置放入对应的 `lua/plugins/*.lua` 文件。

## 检查与排错

```sh
nvim --headless "+qa"  # 验证配置能否正常启动
stylua --check .        # 检查 Lua 格式
git diff --check        # 检查空白错误
```

进入 Neovim 后可使用 `:checkhealth`、`:LspInfo`、`:ConformInfo`、`:Mason` 和 `:Lazy` 查看具体状态。
