local M = {}
local ts_inlay_hints = {
  includeInlayParameterNameHints = "all",
  includeInlayParameterNameHintsWhenArgumentMatchesName = false,
  includeInlayFunctionParameterTypeHints = true,
  includeInlayVariableTypeHints = true,
  includeInlayPropertyDeclarationTypeHints = true,
  includeInlayFunctionLikeReturnTypeHints = true,
  includeInlayEnumMemberValueHints = true,
}

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

function M.project_name(path)
  return vim.fs.basename(path or current_path(0))
end

function M.ts_inlay_settings(language)
  return {
    settings = {
      [language] = {
        inlayHints = vim.deepcopy(ts_inlay_hints),
      },
    },
  }
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
