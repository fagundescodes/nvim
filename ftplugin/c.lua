local utils = require("lsp.utils")
local lsp = require("lsp.helpers")

vim.lsp.start({
  name = "clangd",
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--header-insertion=iwyu",
    "--completion-style=detailed",
    "--function-arg-placeholders",
    "--fallback-style=llvm",
  },
  filetypes = { "c", "cpp" },
  root_dir = lsp.find_root({ "compile_commands.json", "compile_flags.txt", ".git" }),
  init_options = {
    usePlaceholders = true,
    completeUnimported = true,
    clangdFileStatus = true,
  },
  capabilities = utils.capabilities,
})
