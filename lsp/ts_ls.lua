local ts_inlay_hints = {
  includeInlayParameterNameHints = "all",
  includeInlayParameterNameHintsWhenArgumentMatchesName = false,
  includeInlayFunctionParameterTypeHints = true,
  includeInlayVariableTypeHints = true,
  includeInlayPropertyDeclarationTypeHints = true,
  includeInlayFunctionLikeReturnTypeHints = true,
  includeInlayEnumMemberValueHints = true,
}

local function inlay_hints()
  return vim.deepcopy(ts_inlay_hints)
end

return {
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
  },
  root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
  init_options = {
    hostInfo = "neovim",
  },
  settings = {
    javascript = {
      inlayHints = inlay_hints(),
    },
    typescript = {
      inlayHints = inlay_hints(),
    },
  },
}
