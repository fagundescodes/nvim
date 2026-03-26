local utils = require("lsp.utils")
local lsp = require("lsp.helpers")

vim.lsp.start({
  name = "gopls",
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_dir = lsp.find_root({ "go.work", "go.mod", ".git" }),
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
      gofumpt = true,
      completeUnimported = true,
      usePlaceholders = true,
      hints = {
        parameterNames = true,
        rangeVariableTypes = true,
      },
    },
  },
  capabilities = utils.capabilities,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("GoFormat", { clear = false }),
  buffer = 0,
  callback = function()
    vim.lsp.buf.code_action({
      context = {
        only = { "source.organizeImports" },
        diagnostics = {},
      },
      apply = true,
    })
    vim.lsp.buf.format({ async = false })
  end,
})
