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
  return matches[1] and vim.fs.dirname(matches[1]) or nil
end

---判断 package.json 是否声明了 Tailwind CSS 依赖。
---@param path string
---@return boolean
local function package_uses_tailwind(path)
  local ok, lines = pcall(vim.fn.readfile, path)
  if not ok then
    return false
  end

  local decoded, package = pcall(vim.json.decode, table.concat(lines, "\n"))
  if not decoded or type(package) ~= "table" then
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
        return current
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
