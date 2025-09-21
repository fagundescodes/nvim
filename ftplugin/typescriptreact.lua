local utils = require("lsp.utils")

vim.lsp.start({
  name = "ts_ls",
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = { "typescriptreact" },
  root_dir = vim.fs.dirname(
    vim.fs.find({ "package.json", "tsconfig.json", "jsconfig.json", ".git" }, { upward = true })[1]
  ),
  init_options = {
    hostInfo = "neovim",
  },
  settings = {
    typescript = {
      inlayHints = {
        includeInlayParameterNameHints = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
    },
  },
  capabilities = utils.capabilities,
})
