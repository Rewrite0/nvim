# Neovim 配置

一套以 Lua 编写的 Neovim 配置，使用 `lazy.nvim` 管理插件，并通过统一语言注册表管理 LSP、Treesitter、formatter 和 linter。Leader 键为空格。

## 环境要求

- Neovim 0.11 或更高版本
- Git
- Nerd Font（用于图标显示）
- `ripgrep`（Snacks 全文搜索）
- `tree-sitter-cli >= 0.26.1`（安装 Treesitter parser）
- C 编译器（Windows 必须使用 Visual Studio C++ Build Tools 提供的 MSVC `cl.exe`）
- Node.js 与 npm（Mason 安装 Node 生态 LSP 和 `pyright`）
- 可选：GitHub Copilot 账号（AI 幽灵文本补全）
- Go 工具链（Go 格式化和 `gopls` 安装）
- Rustup 管理的 Rust 工具链，并安装 `rustfmt` 与 `clippy` 组件
- 可选：`lazygit`（终端 Git 界面）
- 可选：ImageMagick（Snacks 图片查看器转换非 PNG 格式）
- 可选：支持 Kitty Graphics Protocol 的 Kitty、Ghostty 或 WezTerm（Snacks 行内图片渲染）

## 安装

备份已有配置后，将本仓库放到 Neovim 配置目录：

```sh
git clone https://github.com/rewrite0/nvim ~/.config/nvim
nvim
```

首次启动时会自动安装 `lazy.nvim`、声明的插件和语言工具。使用 `:Lazy` 查看插件状态，使用 `:Mason` 查看 LSP、formatter 和 linter。

使用 AI 幽灵文本补全前，执行 `:Copilot auth` 登录 GitHub Copilot。

## 插件说明

| 插件 | 用途 |
| --- | --- |
| [folke/lazy.nvim](https://github.com/folke/lazy.nvim) | 插件安装、锁定和懒加载 |
| [catppuccin/nvim](https://github.com/catppuccin/nvim) | Catppuccin Macchiato 配色 |
| [nvim-lualine/lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) | 全局状态栏 |
| [akinsho/bufferline.nvim](https://github.com/akinsho/bufferline.nvim) | Buffer 标签栏和 LSP 诊断标记 |
| [folke/snacks.nvim](https://github.com/folke/snacks.nvim) | 启动页、文件浏览、Picker、通知、终端、专注模式、临时缓冲区及文本辅助功能 |
| [folke/which-key.nvim](https://github.com/folke/which-key.nvim) | Leader 快捷键提示 |
| [folke/flash.nvim](https://github.com/folke/flash.nvim) | 快速文本和 Treesitter 结构跳转 |
| [folke/trouble.nvim](https://github.com/folke/trouble.nvim) | 诊断、符号、LSP 和 quickfix 列表 |
| [echasnovski/mini.surround](https://github.com/echasnovski/mini.surround) | 添加、删除和替换文本环绕符号 |
| [numToStr/Comment.nvim](https://github.com/numToStr/Comment.nvim) | 切换当前行或选区的行注释 |
| [nvim-tree/nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons) | 文件和界面图标 |
| [neovim/nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | 基于 Neovim 原生 API 配置 LSP |
| [mason-org/mason.nvim](https://github.com/mason-org/mason.nvim) | 安装和管理 LSP 服务 |
| [mason-org/mason-lspconfig.nvim](https://github.com/mason-org/mason-lspconfig.nvim) | 将 Mason 与 LSP 配置连接起来 |
| [WhoIsSethDaniel/mason-tool-installer.nvim](https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim) | 根据语言注册表自动安装 formatter 和 linter |
| [saghen/blink.cmp](https://github.com/Saghen/blink.cmp) | 插入模式与命令行实时补全 |
| [zbirenbaum/copilot.lua](https://github.com/zbirenbaum/copilot.lua) | GitHub Copilot 幽灵文本补全 |
| [L3MON4D3/LuaSnip](https://github.com/L3MON4D3/LuaSnip) | 代码片段引擎 |
| [rafamadriz/friendly-snippets](https://github.com/rafamadriz/friendly-snippets) | 通用代码片段集合 |
| [nvim-treesitter/nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | 语法高亮与缩进 |
| [kevinhwang91/nvim-ufo](https://github.com/kevinhwang91/nvim-ufo) | 基于 Treesitter 的异步代码折叠与折叠预览 |
| [windwp/nvim-autopairs](https://github.com/windwp/nvim-autopairs) | 自动补全括号、引号等成对符号 |
| [stevearc/conform.nvim](https://github.com/stevearc/conform.nvim) | 保存时和手动格式化 |
| [mfussenegger/nvim-lint](https://github.com/mfussenegger/nvim-lint) | 保存、进入 Buffer 和离开插入模式时 lint |
| [lewis6991/gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | Git 变更块、预览、暂存和还原 |
| [folke/persistence.nvim](https://github.com/folke/persistence.nvim) | 保存和恢复项目会话 |
| [j-hui/fidget.nvim](https://github.com/j-hui/fidget.nvim) | 显示 LSP 初始化和处理进度 |

插件版本记录在 `lazy-lock.json` 中。

## 语言支持

语言配置集中在 `lua/config/languages.lua`，由 `lua/utils/language_registry.lua` 校验并提供给各插件。

| 语言/文件类型 | LSP | Formatter | Linter |
| --- | --- | --- | --- |
| Lua | `lua_ls` | `stylua` | 无 |
| Go | `gopls` | `gofmt` | `golangci-lint` |
| Rust | `rust_analyzer` | `rustfmt` | `clippy`（通过 `rust-analyzer`） |
| Python | `pyright` | Ruff | Ruff |
| HTML | `html` + `emmet_language_server` | 无 | 无 |
| JavaScript / TypeScript / JSX / TSX（Node） | `ts_ls` + Emmet | `prettier` | `eslint` |
| JavaScript / TypeScript / JSX / TSX（Deno） | `denols` + Emmet | `deno fmt` | `deno lint` |
| Vue（Node） | `vue_ls` + `ts_ls` Vue 插件 + Emmet | `prettier` | `eslint` |
| Astro（Node） | `astro` + Emmet | `prettier` | `eslint` |
| Vue / Astro（Deno） | Emmet（无框架专用 LSP） | `deno fmt` | 无 |
| CSS / SCSS / Less | `cssls` | 随 Node/Deno 项目选择 `prettier` 或 `deno fmt` | 无 |
| JSON / JSONC / YAML / Markdown | 无 | 随 Node/Deno 项目选择 `prettier` 或 `deno fmt` | 无 |

Node 项目通过 `package.json`、`tsconfig.json` 或 `jsconfig.json` 识别；Deno 项目通过 `deno.json` 或 `deno.jsonc` 识别。Deno 优先级更高，同一路径下不会同时启动 `denols` 和 `ts_ls`。不属于 Node 或 Deno 项目的文件不会自动选择对应 formatter/linter。

Mason 自动安装 `lua_ls`、`gopls`、`rust_analyzer`、`pyright`、`denols`、`ts_ls`、`vue_ls`、Astro LSP、HTML LSP、CSS LSP、Emmet Language Server，以及 `stylua`、`golangci-lint`、Ruff、`prettier` 和 `deno`。Emmet 补全适用于 HTML、JavaScript、JSX、TypeScript、TSX、Vue 和 Astro。`cssls` 同时支持 CSS、SCSS 和 Less。`gofmt` 由 Go 工具链提供；`rustfmt` 和 `clippy` 由 Rustup 组件提供。Mason 不提供供 `nvim-lint` 直接调用的普通 ESLint CLI，因此 Node 项目需在项目依赖中安装并配置 `eslint`。

## 常用快捷键

### 基础与 Buffer

| 快捷键 | 功能 |
| --- | --- |
| `<leader>s` / `<C-s>` | 保存文件 |
| `<leader>w` | 关闭当前 Buffer 标签并保持分屏布局 |
| `<leader>q` | 关闭当前窗口 |
| `<leader>m` | 打开 Mason |
| `<leader>l` | 打开 Lazy |
| `:Reload` | 重载用户配置 |
| `<S-h>` / `<S-l>` | 上一个 / 下一个 Buffer 标签 |
| `<leader>bd` | 选择并关闭 Buffer 标签 |
| `<C-h/j/k/l>` | 聚焦相邻窗口 |
| `<方向键>` | 沿箭头方向移动窗口分隔线（每次 5 行/列） |
| `<C-方向键>` | 沿箭头方向微调窗口分隔线（每次 1 行/列） |
| `;` | 进入命令行（等同于 `:`） |
| `<Esc>` | 清除搜索高亮 |
| `<C-/>` | 切换当前行或选区注释 |
| `s` / `S` | Flash 快速跳转 / Treesitter 结构跳转 |
| `gsa` / `gsd` / `gsr` | 添加 / 删除 / 替换文本环绕 |

### 查找与浏览

| 快捷键 | 功能 |
| --- | --- |
| `<leader>ff` | 查找文件 |
| `<leader>fg` | 全文搜索 |
| `<leader>fb` | 查找 Buffer |
| `<leader>fr` | 最近文件 |
| `<leader>fn` | 查看通知历史 |
| `<leader>e` | 文件浏览器 |

### LSP 与代码质量

以下 LSP 快捷键仅在服务附加到当前 Buffer 后生效。

| 快捷键 | 功能 |
| --- | --- |
| `gd` / `gD` | 跳转到定义 / 声明 |
| `gr` | 查找引用 |
| `K` | 预览光标下的折叠内容；无折叠时显示悬浮文档 |
| `<leader>cr` | 重命名符号 |
| `<leader>ca` | 代码操作 |
| `[d` / `]d` | 上一个 / 下一个诊断 |
| `<leader>cf` | 格式化当前 Buffer 或选区 |
| `<leader>cl` | 手动运行当前项目的 linter |
| `<leader>xx` / `<leader>xX` | 打开全部 / 当前 Buffer 诊断 |
| `<leader>xs` | 打开当前 Buffer 符号列表 |
| `<leader>xl` | 打开当前 Buffer LSP 列表 |
| `<leader>xq` / `<leader>xL` | 打开 quickfix / location list |
| `[r` / `]r` | 上一个 / 下一个当前符号的 LSP 文档高亮引用 |

### AI 补全

| 快捷键 | 功能 |
| --- | --- |
| `<A-l>` | 接受 GitHub Copilot 幽灵文本建议 |

### 代码折叠

折叠范围优先由 Treesitter 提供，无法获得 Treesitter 折叠范围时回退到缩进。打开文件时默认展开全部折叠；收起后在折叠文本末尾显示隐藏的行数。

| 快捷键 | 功能 |
| --- | --- |
| `zc` / `zo` / `za` | 收起 / 展开 / 切换光标所在折叠 |
| `zm` / `zr` | 在整个窗口收起 / 展开一层折叠；数字前缀指定调整层数，例如 `2zm` |
| `zM` / `zR` | 收起 / 展开全部折叠 |
| `K` | 预览光标下的折叠内容；无折叠时显示 LSP 悬浮文档 |

### Snacks 界面与开关

| 快捷键 | 功能 |
| --- | --- |
| `<leader>.` | 打开或隐藏项目关联的临时缓冲区 |
| `<leader>S` | 选择临时缓冲区 |
| `<leader>z` | 切换 Zen 专注模式 |
| `<leader>ud` | 切换诊断显示（带状态图标） |
| `<leader>uh` | 切换 LSP Inlay Hints（带状态图标） |
| `<leader>us` | 切换拼写检查（带状态图标） |
| `<leader>tt` | 切换 Snacks 终端 |
| `<leader>tf` | 切换 Snacks 浮动终端 |
| `<leader>tr` | 切换 Snacks 右侧终端 |

Snacks 终端窗口可以使用 Neovim 的窗口命令继续布局：`<C-w>v` 垂直拆分、`<C-w>s` 水平拆分。拆分窗口会复用同一个终端进程；要创建独立终端，请使用数字前缀，例如 `2<leader>tt`。

### 会话

| 快捷键 | 功能 |
| --- | --- |
| `<leader>ps` | 恢复当前目录会话 |
| `<leader>pS` | 选择会话 |
| `<leader>pl` | 恢复最近会话 |
| `<leader>pd` | 停止保存会话 |

### Git

| 快捷键 | 功能 |
| --- | --- |
| `]h` / `[h` | 下一个 / 上一个 Git 变更块 |
| `<leader>gs` | 暂存当前变更块 |
| `<leader>gr` | 还原当前变更块 |
| `<leader>gp` | 预览当前变更块 |
| `<leader>gg` | 打开 Lazygit |
| `<leader>gb` | 查看当前行 Git 追溯 |
| `<leader>go` | 在浏览器打开当前 Git 文件/行 |

## 目录结构

```text
init.lua                      # 配置入口与 lazy.nvim 引导
lua/config/                   # 选项、快捷键、自动命令和语言声明
lua/plugins/                  # 按功能拆分的插件规格
lua/utils/language_registry.lua # 语言注册表校验与派生逻辑
stylua.toml                   # StyLua 格式化规则
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

### Treesitter 编译器

`nvim-treesitter` 安装 parser 时需要 C 编译器。Windows 必须安装 Visual Studio Build Tools，并选择“使用 C++ 的桌面开发”工作负载，确保 MSVC C++ 工具集和 Windows SDK 均已安装。配置会清除 Windows 下可能指向 Clang/GCC 的 `CC`，由 `tree-sitter` 自动发现并使用 MSVC 编译环境。

`fatal error: 'stdlib.h' file not found` 并非 Windows 专属错误；它表示当前编译器找不到 C 标准库头文件。在 Windows 上出现该错误时，请检查上述 Build Tools 组件是否完整安装，然后执行 `:TSInstall css scss` 重试安装。

Windows 用户可在 Visual Studio Installer 中安装或修改 Visual Studio Build Tools，勾选“使用 C++ 的桌面开发”工作负载后补齐所需组件。

启动 Neovim 后可执行 `:lua require("nvim-treesitter").install({ "astro" })` 重新安装 Astro parser。
