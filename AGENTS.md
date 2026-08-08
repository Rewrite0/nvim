# Repository Guidelines

## 项目结构与模块组织

- `init.lua` 是入口文件，设置 Leader 键、加载基础配置并引导 `lazy.nvim`。
- `lua/config/` 存放编辑器选项、快捷键、自动命令、代码片段和语言声明。新增语言时优先修改 `lua/config/languages.lua`。
- `lua/plugins/` 按功能拆分插件规格，例如 `lsp.lua`、`lint.lua` 和 `ui.lua`。一个文件可包含同一领域的多个插件。
- `lua/utils/language_registry.lua` 负责校验并转换语言注册表。通用逻辑放在此处，不要堆入声明文件。
- `lazy-lock.json` 锁定插件版本；插件变更后应一并检查该文件。

## 开发与验证命令

本仓库无需构建。直接在仓库目录启动 Neovim 进行开发：

```sh
nvim
nvim --headless "+qa"                 # 验证配置能够启动
stylua --check .                       # 检查 Lua 格式
stylua .                               # 格式化 Lua 文件
nvim --headless "+Lazy! sync" "+qa"  # 同步并验证插件
```

交互式排查使用 `:checkhealth`；LSP、格式化或 lint 问题还应在对应语言项目中打开文件验证。

## 编码风格与命名约定

Lua 使用两个空格缩进、双引号和尾随逗号，并保持 Stylua 兼容。模块、文件和局部函数采用 `snake_case`；插件规格保持声明式，复杂处理抽到 `lua/utils/`。公开或不直观的方法使用简短 LuaLS 注释（`---@param`、`---@return`）。不要手工编辑第三方插件源码或提交本地缓存目录。

## 测试指南

目前没有自动化测试框架或覆盖率要求。每次修改至少运行 Stylua 检查和无界面启动测试。涉及快捷键时用 `:map` 检查冲突；涉及语言工具时验证 Node/Deno 项目识别、LSP 附加以及 formatter/linter 实际输出。提交前运行 `git diff --check`。

## 提交与 Pull Request

提交历史采用 Conventional Commits 前缀和简洁中文说明，例如 `feat: 命令行实时补全`、`refactor: 集中管理语言工具注册表`。一次提交只处理一个主题。

Pull Request 应说明行为变化、验证命令及受影响的语言或插件；界面调整附截图，配置兼容性变更注明 Neovim 或插件版本要求。不要提交密钥、机器专属绝对路径或运行时生成文件。
