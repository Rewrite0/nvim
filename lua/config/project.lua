local M = {}

local tailwind_config_files = {
  "tailwind.config.js",
  "tailwind.config.cjs",
  "tailwind.config.mjs",
  "tailwind.config.ts",
  "tailwind.config.cts",
  "tailwind.config.mts",
}

local package_dependency_fields = {
  "dependencies",
  "devDependencies",
  "optionalDependencies",
  "peerDependencies",
}

local node_workspace_markers = {
  "pnpm-workspace.yaml",
  "pnpm-lock.yaml",
  "yarn.lock",
  "package-lock.json",
  "bun.lock",
  "bun.lockb",
}

local javascript_filetypes = {
  javascript = true,
  javascriptreact = true,
  typescript = true,
  typescriptreact = true,
}

---规范化项目根路径；仅 Windows 解析真实路径，避免大小写差异产生重复 workspace。
---@param path string
---@return string
local function normalize_project_root(path)
  if vim.fn.has("win32") == 1 then
    path = vim.uv.fs_realpath(path) or path
    return vim.fs.normalize(path)
  end
  return path
end

---将缓冲区编号或文件路径统一转换为用于项目检测的起始路径。
---@param bufnr_or_path integer|string
---@return string
local function path_for(bufnr_or_path)
  if type(bufnr_or_path) == "number" then
    local name = vim.api.nvim_buf_get_name(bufnr_or_path)
    return name ~= "" and name or vim.uv.cwd()
  end
  return bufnr_or_path ~= "" and bufnr_or_path or vim.uv.cwd()
end

---返回起始路径本身或其所在目录。
---@param bufnr_or_path integer|string
---@return string
local function directory_for(bufnr_or_path)
  local path = path_for(bufnr_or_path)
  local stat = vim.uv.fs_stat(path)
  return stat and stat.type == "directory" and path or vim.fs.dirname(path)
end

---从起始路径向上查找任一标记文件，并返回标记文件所在目录。
---@param markers string[]
---@param start integer|string
---@return string?
local function find_upward(markers, start)
  local matches = vim.fs.find(markers, {
    path = path_for(start),
    upward = true,
    stop = vim.uv.os_homedir(),
  })
  return matches[1] and normalize_project_root(vim.fs.dirname(matches[1])) or nil
end

---读取 JSON 文件并返回对象。
---@param path string
---@return table?
local function read_json_object(path)
  local ok, lines = pcall(vim.fn.readfile, path)
  if not ok then
    return nil
  end

  local decoded, value = pcall(vim.json.decode, table.concat(lines, "\n"))
  return decoded and type(value) == "table" and value or nil
end

---判断 package.json 是否声明了 Tailwind CSS 依赖。
---@param path string
---@return boolean
local function package_uses_tailwind(path)
  local package = read_json_object(path)
  if not package then
    return false
  end

  for _, field in ipairs(package_dependency_fields) do
    local dependencies = package[field]
    if type(dependencies) == "table" then
      for name in pairs(dependencies) do
        if name == "tailwindcss" or name:match("^@tailwindcss/") then
          return true
        end
      end
    end
  end
  return false
end

---判断 package.json 是否声明了 workspace。
---@param path string
---@return boolean
local function package_declares_workspace(path)
  local package = read_json_object(path)
  return package ~= nil and type(package.workspaces) == "table"
end

---查找包含当前 Node 子包的 workspace 根目录。
---@param bufnr_or_path integer|string
---@param package_root string
---@return string
local function node_workspace_root(bufnr_or_path, package_root)
  local current = directory_for(bufnr_or_path)
  local git_root = find_upward({ ".git" }, bufnr_or_path)
  local home = vim.fs.normalize(vim.uv.os_homedir())

  while current do
    if not git_root and vim.fs.normalize(current) == home then
      break
    end

    for _, marker in ipairs(node_workspace_markers) do
      if vim.uv.fs_stat(vim.fs.joinpath(current, marker)) then
        return normalize_project_root(current)
      end
    end

    local package_path = vim.fs.joinpath(current, "package.json")
    if vim.uv.fs_stat(package_path) and package_declares_workspace(package_path) then
      return current
    end

    if current == git_root then
      break
    end
    local parent = vim.fs.dirname(current)
    if not parent or parent == current then
      break
    end
    current = parent
  end

  return normalize_project_root(package_root)
end

---查找当前子包的 Tailwind CSS 项目根目录，不跨越最近的 package.json。
---@param bufnr_or_path integer|string
---@return string?
function M.tailwind_root(bufnr_or_path)
  local start = path_for(bufnr_or_path)
  local stat = vim.uv.fs_stat(start)
  local current = stat and stat.type == "directory" and start or vim.fs.dirname(start)

  while current do
    for _, name in ipairs(tailwind_config_files) do
      if vim.uv.fs_stat(vim.fs.joinpath(current, name)) then
        return normalize_project_root(current)
      end
    end

    local package_path = vim.fs.joinpath(current, "package.json")
    if vim.uv.fs_stat(package_path) then
      return package_uses_tailwind(package_path) and current or nil
    end

    local parent = vim.fs.dirname(current)
    if not parent or parent == current then
      return nil
    end
    current = parent
  end
end

---查找包含当前文件的 Deno 项目根目录。
---@param bufnr_or_path integer|string
---@return string?
function M.deno_root(bufnr_or_path)
  return find_upward({ "deno.json", "deno.jsonc" }, bufnr_or_path)
end

---查找 Node 项目根目录；任意上级存在 Deno 配置时不识别为 Node 项目。
---@param bufnr_or_path integer|string
---@return string?
function M.node_root(bufnr_or_path)
  if M.deno_root(bufnr_or_path) then
    return nil
  end
  return find_upward({ "tsconfig.json", "jsconfig.json", "package.json" }, bufnr_or_path)
end

---查找 Deno 项目根目录；独立 JS/TS 脚本回退到所在目录，Node 项目不匹配。
---@param bufnr_or_path integer|string
---@return string?
function M.deno_root_or_script_dir(bufnr_or_path)
  local root = M.deno_root(bufnr_or_path)
  if root then
    return root
  end
  if M.node_root(bufnr_or_path) then
    return nil
  end
  if type(bufnr_or_path) == "number" and javascript_filetypes[vim.bo[bufnr_or_path].filetype] then
    return normalize_project_root(directory_for(bufnr_or_path))
  end
end

---查找 Node 或 Deno 项目根目录，Deno 配置优先。
---@param bufnr_or_path integer|string
---@return string?
function M.framework_root(bufnr_or_path)
  return M.deno_root(bufnr_or_path) or M.node_root(bufnr_or_path)
end

---查找 TypeScript workspace 根目录；Deno 项目仅为 Vue 文件启用。
---@param bufnr_or_path integer|string
---@return string?
function M.typescript_root(bufnr_or_path)
  local deno_root = M.deno_root(bufnr_or_path)
  if deno_root then
    if type(bufnr_or_path) == "number" and vim.bo[bufnr_or_path].filetype == "vue" then
      return deno_root
    end
    return nil
  end

  local package_root = M.node_root(bufnr_or_path)
  if package_root then
    return normalize_project_root(node_workspace_root(bufnr_or_path, package_root))
  end
end

---判断当前文件是否属于 Deno 项目。
---@param bufnr_or_path integer|string
---@return boolean
function M.is_deno(bufnr_or_path)
  return M.deno_root(bufnr_or_path) ~= nil
end

---判断当前文件是否属于 Node 项目，并遵循 Deno 优先规则。
---@param bufnr_or_path integer|string
---@return boolean
function M.is_node(bufnr_or_path)
  return M.node_root(bufnr_or_path) ~= nil
end

return M
