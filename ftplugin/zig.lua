local utils = require("lsp.utils")
local lsp = require("lsp.helpers")

vim.lsp.start({
  name = "zls",
  cmd = { "zls" },
  filetypes = { "zig", "zir" },
  root_dir = lsp.find_root({ "build.zig", ".git" }),
  capabilities = utils.capabilities,
})

vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.expandtab = true
