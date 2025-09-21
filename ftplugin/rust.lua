local utils = require("lsp.utils")

vim.lsp.start({
  name = "rust_analyzer",
  cmd = { "rust-analyzer" },
  filetypes = { "rust" },
  root_dir = vim.fs.dirname(vim.fs.find({ "Cargo.toml", "Cargo.lock", ".git" }, { upward = true })[1]),
  settings = {
    ["rust-analyzer"] = {
      cargo = {
        allFeatures = true,
        loadOutDirsFromCheck = true,
        runBuildScripts = true,
      },
      checkOnSave = true,
      procMacro = {
        enable = true,
        ignored = {
          ["async-trait"] = { "async_trait" },
          ["napi-derive"] = { "napi" },
          ["async-recursion"] = { "async_recursion" },
        },
      },
    },
  },
  capabilities = utils.capabilities,
})
