local utils = require("lsp.utils")

vim.lsp.start({
  name = "gopls",
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork" },
  root_dir = vim.fs.dirname(vim.fs.find({ "go.mod", "go.work", ".git" }, { upward = true })[1]),
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
      gofumpt = true,
      completeUnimported = true,
      usePlaceholders = true,
      experimentalPostfixCompletions = true,
      hoverKind = "FullDocumentation",
      linkTarget = "pkg.go.dev",
      codelenses = {
        gc_details = false,
        generate = true,
        regenerate_cgo = true,
        run_govulncheck = true,
        test = true,
        tidy = true,
        upgrade_dependency = true,
        vendor = true,
      },
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
    },
  },
  capabilities = utils.capabilities,
  on_attach = function(client, bufnr)
    utils.on_attach(client, bufnr)

    -- vim.api.nvim_create_autocmd("BufWritePre", {
    --   buffer = bufnr,
    --   callback = function()
    --     vim.lsp.buf.format({ async = false })
    --   end,
    -- })
  end,
})
