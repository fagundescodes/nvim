local M = {}

local function current_path(bufnr)
  local name = vim.api.nvim_buf_get_name(bufnr or 0)
  if name == "" then
    return vim.uv.cwd()
  end
  return vim.fs.dirname(name)
end

function M.find_root(markers, bufnr)
  local path = current_path(bufnr)
  local found = vim.fs.find(markers, {
    upward = true,
    path = path,
    stop = vim.env.HOME,
  })[1]

  if found then
    return vim.fs.dirname(found)
  end

  return vim.uv.cwd()
end

function M.find_root_by_glob(patterns, bufnr)
  local path = current_path(bufnr)

  while path and path ~= "" do
    for _, pattern in ipairs(patterns) do
      local matches = vim.fn.globpath(path, pattern, false, true)
      if #matches > 0 then
        return path
      end
    end

    local parent = vim.fs.dirname(path)
    if parent == path or parent == vim.env.HOME then
      break
    end
    path = parent
  end

  return M.find_root({ ".git" }, bufnr)
end

function M.ts_server_config(filetypes, extra)
  local utils = require("lsp.utils")
  local config = {
    name = "ts_ls",
    cmd = { "typescript-language-server", "--stdio" },
    filetypes = filetypes,
    root_dir = M.find_root({ "package.json", "tsconfig.json", "jsconfig.json", ".git" }),
    init_options = {
      hostInfo = "neovim",
    },
    capabilities = utils.capabilities,
  }

  if extra then
    return vim.tbl_deep_extend("force", config, extra)
  end

  return config
end

return M
