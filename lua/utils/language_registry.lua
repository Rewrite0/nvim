---@alias ProjectRootDetector fun(bufnr: integer): string?
---@alias ToolMap table<string, string[]>

---@class LanguageToolsDefinition
---@field mason string[]
---@field formatters ToolMap
---@field linters ToolMap

---@class LanguageLspDefinition
---@field name string
---@field mason boolean|string
---@field root ProjectRootDetector|false
---@field config vim.lsp.Config

---@alias LanguageLspDefinitions LanguageLspDefinition|LanguageLspDefinition[]|false

---@class LanguageProjectDefinition
---@field priority integer
---@field root ProjectRootDetector
---@field lsp LanguageLspDefinitions
---@field tools LanguageToolsDefinition

---@class LanguageDefinitionSpec
---@field filetypes string[]
---@field treesitter string[]
---@field lsp LanguageLspDefinitions
---@field tools LanguageToolsDefinition|false
---@field toolchain string|false
---@field projects table<string, LanguageProjectDefinition>

---@class LanguageDefinition: LanguageDefinitionSpec
---@field name string

local M = {}

---@type table<string, LanguageDefinition>
M.definitions = {}

local filetype_languages = {}

---校验字符串数组。
---@param name string
---@param values unknown
local function validate_string_list(name, values)
  assert(type(values) == "table" and vim.islist(values), name .. " 必须是数组")
  for index, value in ipairs(values) do
    assert(type(value) == "string", ("%s[%d] 必须是字符串"):format(name, index))
  end
end

---校验 LSP 定义。
---@param path string
---@param definition LanguageLspDefinitions
local function validate_lsp(path, definition)
  if definition == false then
    return
  end
  if vim.islist(definition) then
    assert(#definition > 0, path .. " 不能为空数组")
    for index, item in ipairs(definition) do
      validate_lsp(("%s[%d]"):format(path, index), item)
    end
    return
  end
  assert(type(definition) == "table", path .. " 必须是 LSP 定义或 false")
  assert(type(definition.name) == "string", path .. ".name 必须是字符串")
  assert(
    type(definition.mason) == "boolean" or type(definition.mason) == "string",
    path .. ".mason 必须是布尔值或 Mason 包名"
  )
  assert(
    definition.root == false or type(definition.root) == "function",
    path .. ".root 必须是项目根检测函数或 false"
  )
  assert(type(definition.config) == "table", path .. ".config 必须是 table")
end

---校验按 filetype 声明的工具映射。
---@param path string
---@param tools ToolMap
local function validate_tool_map(path, tools)
  assert(type(tools) == "table", path .. " 必须是 table")
  for filetype, names in pairs(tools) do
    assert(type(filetype) == "string", path .. " 的键必须是 filetype")
    validate_string_list(path .. "." .. filetype, names)
  end
end

---校验 formatter、linter 及其 Mason 包定义。
---@param path string
---@param tools LanguageToolsDefinition|false
local function validate_tools(path, tools)
  if tools == false then
    return
  end
  assert(type(tools) == "table", path .. " 必须是工具定义或 false")
  for _, field in ipairs({ "mason", "formatters", "linters" }) do
    assert(tools[field] ~= nil, ("工具配置 %q 缺少字段 %q"):format(path, field))
  end
  validate_string_list(path .. ".mason", tools.mason)
  validate_tool_map(path .. ".formatters", tools.formatters)
  validate_tool_map(path .. ".linters", tools.linters)
end

---校验单个语言定义及其项目配置。
---@param name string
---@param definition LanguageDefinitionSpec
local function validate_language(name, definition)
  for _, field in ipairs({ "filetypes", "treesitter", "lsp", "tools", "toolchain", "projects" }) do
    assert(definition[field] ~= nil, ("语言 %q 缺少字段 %q"):format(name, field))
  end

  validate_string_list(name .. ".filetypes", definition.filetypes)
  validate_string_list(name .. ".treesitter", definition.treesitter)
  validate_lsp(name .. ".lsp", definition.lsp)
  validate_tools(name .. ".tools", definition.tools)
  assert(
    definition.toolchain == false or type(definition.toolchain) == "string",
    name .. ".toolchain 必须是语言名称或 false"
  )
  assert(type(definition.projects) == "table", name .. ".projects 必须是 table")

  for project_name, project_definition in pairs(definition.projects) do
    local path = name .. ".projects." .. project_name
    for _, field in ipairs({ "priority", "root", "lsp", "tools" }) do
      assert(project_definition[field] ~= nil, ("项目配置 %q 缺少字段 %q"):format(path, field))
    end
    assert(type(project_definition.priority) == "number", path .. ".priority 必须是数字")
    assert(type(project_definition.root) == "function", path .. ".root 必须是函数")
    validate_lsp(path .. ".lsp", project_definition.lsp)
    validate_tools(path .. ".tools", project_definition.tools)
  end
end

---建立 filetype 索引并校验跨语言引用。
local function index_definitions()
  filetype_languages = {}

  for language_name, definition in pairs(M.definitions) do
    if definition.toolchain then
      local toolchain = M.definitions[definition.toolchain]
      assert(toolchain, ("语言 %q 引用了未知工具链 %q"):format(language_name, definition.toolchain))
      assert(next(toolchain.projects), ("工具链 %q 没有项目配置"):format(definition.toolchain))
      assert(
        not next(definition.projects),
        ("语言 %q 不能同时声明 toolchain 和 projects"):format(language_name)
      )
    end

    for _, filetype in ipairs(definition.filetypes) do
      assert(
        not filetype_languages[filetype],
        ("filetype %q 同时属于 %q 和 %q"):format(filetype, filetype_languages[filetype] or "", language_name)
      )
      filetype_languages[filetype] = language_name
    end
  end

  for language_name, language in pairs(M.definitions) do
    for project_name, definition in pairs(language.projects) do
      for kind, tools in pairs({
        formatters = definition.tools.formatters,
        linters = definition.tools.linters,
      }) do
        for filetype in pairs(tools) do
          assert(
            filetype_languages[filetype],
            ("%s.projects.%s.%s 使用了未知 filetype %q"):format(language_name, project_name, kind, filetype)
          )
        end
      end
    end
  end
end

---加载并校验语言定义。
---@param definitions table<string, LanguageDefinitionSpec>
---@return table
function M.setup(definitions)
  for name, definition in pairs(definitions) do
    validate_language(name, definition)
    definition.name = name
  end
  M.definitions = definitions
  index_definitions()
  return M
end

---返回缓冲区对应的语言定义。
---@param bufnr integer
---@return LanguageDefinition?
function M.language_for(bufnr)
  local name = filetype_languages[vim.bo[bufnr].filetype]
  return name and M.definitions[name] or nil
end

---解析语言当前匹配的项目配置，优先级高的配置先匹配。
---@param language LanguageDefinition
---@param bufnr integer
---@return LanguageProjectDefinition?, string?, string?
function M.resolve_project(language, bufnr)
  local toolchain = language.toolchain and M.definitions[language.toolchain] or language
  local matches = {}

  for name, definition in pairs(toolchain.projects) do
    local root = definition.root(bufnr)
    if root then
      matches[#matches + 1] = { name = name, definition = definition, root = root }
    end
  end

  table.sort(matches, function(left, right)
    return left.definition.priority > right.definition.priority
  end)

  if matches[1] and matches[2] and matches[1].definition.priority == matches[2].definition.priority then
    error(("项目配置 %q 和 %q 同时匹配且优先级相同"):format(matches[1].name, matches[2].name))
  end

  local match = matches[1]
  return match and match.definition or nil, match and match.root or nil, match and match.name or nil
end

---返回当前缓冲区应使用的 formatter 列表。
---@param bufnr integer
---@return string[]
function M.formatters_for(bufnr)
  local language = M.language_for(bufnr)
  if not language then
    return {}
  end
  local definition = M.resolve_project(language, bufnr)
  local toolchain = language.toolchain and M.definitions[language.toolchain] or language
  local tools = definition and definition.tools or language.tools or toolchain.tools
  return tools and tools.formatters[vim.bo[bufnr].filetype] or {}
end

---返回当前缓冲区应使用的 linter 列表。
---@param bufnr integer
---@return string[]
function M.linters_for(bufnr)
  local language = M.language_for(bufnr)
  if not language then
    return {}
  end
  local definition = M.resolve_project(language, bufnr)
  local tools = definition and definition.tools or language.tools
  return tools and tools.linters[vim.bo[bufnr].filetype] or {}
end

---汇总并去重需要 Mason 安装的 formatter 和 linter。
---@return string[]
function M.mason_tools()
  local seen, tools = {}, {}

  ---加入工具定义中尚未记录的 Mason 包。
  ---@param definition LanguageToolsDefinition|false
  local function add(definition)
    if not definition then
      return
    end
    for _, name in ipairs(definition.mason) do
      if not seen[name] then
        seen[name] = true
        tools[#tools + 1] = name
      end
    end
  end

  for _, language in pairs(M.definitions) do
    add(language.tools)
    for _, definition in pairs(language.projects) do
      add(definition.tools)
    end
  end
  table.sort(tools)
  return tools
end

---汇总并去重所有 Treesitter parser。
---@return string[]
function M.treesitter_parsers()
  local seen, parsers = {}, {}
  for _, definition in pairs(M.definitions) do
    for _, parser in ipairs(definition.treesitter) do
      if not seen[parser] then
        seen[parser] = true
        parsers[#parsers + 1] = parser
      end
    end
  end
  table.sort(parsers)
  return parsers
end

---复制 LSP 配置并注入项目根目录检测。
---@param definition LanguageLspDefinition
---@param fallback_root? ProjectRootDetector
---@return vim.lsp.Config
local function resolve_lsp_config(definition, fallback_root)
  local config = vim.deepcopy(definition.config)
  local root = definition.root or fallback_root
  if root then
    config.root_dir = function(bufnr, on_dir)
      local root_dir = root(bufnr)
      if root_dir then
        on_dir(root_dir)
      end
    end
  end
  return config
end

---汇总所有 LSP 配置。
---@return table<string, vim.lsp.Config>
function M.lsp_configs()
  local configs = {}

  ---加入一个尚未注册的 LSP 配置。
  ---@param definition LanguageLspDefinition
  ---@param fallback_root? ProjectRootDetector
  local function add(definition, fallback_root)
    assert(not configs[definition.name], "重复的 LSP 配置：" .. definition.name)
    configs[definition.name] = resolve_lsp_config(definition, fallback_root)
  end

  ---加入一个或多个 LSP 定义。
  ---@param definitions LanguageLspDefinitions
  ---@param fallback_root? ProjectRootDetector
  local function add_all(definitions, fallback_root)
    if not definitions then
      return
    end
    if vim.islist(definitions) then
      for _, definition in ipairs(definitions) do
        add(definition, fallback_root)
      end
    else
      add(definitions, fallback_root)
    end
  end

  for _, language in pairs(M.definitions) do
    add_all(language.lsp)
    for _, definition in pairs(language.projects) do
      add_all(definition.lsp, definition.root)
    end
  end
  return configs
end

---汇总并去重需要 Mason 安装的 LSP。
---@return string[]
function M.mason_servers()
  local seen, servers = {}, {}

  ---加入一个尚未记录的 Mason LSP 包。
  ---@param definitions LanguageLspDefinitions
  local function add(definitions)
    if not definitions then
      return
    end
    if vim.islist(definitions) then
      for _, definition in ipairs(definitions) do
        add(definition)
      end
      return
    end
    local definition = definitions
    if definition.mason then
      local name = type(definition.mason) == "string" and definition.mason or definition.name
      if not seen[name] then
        seen[name] = true
        servers[#servers + 1] = name
      end
    end
  end

  for _, language in pairs(M.definitions) do
    add(language.lsp)
    for _, definition in pairs(language.projects) do
      add(definition.lsp)
    end
  end
  table.sort(servers)
  return servers
end

return M
