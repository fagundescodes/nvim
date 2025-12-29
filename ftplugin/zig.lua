local utils = require("lsp.utils")

vim.lsp.start({
  name = "zls",
  cmd = { "zls" },
  filetypes = { "zig", "zir" },
  root_dir = vim.fs.dirname(vim.fs.find({ "build.zig", ".git" }, { upward = true })[1]),
  capabilities = utils.capabilities,
  on_attach = utils.on_attach,
})

vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.expandtab = true
