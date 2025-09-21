local utils = require("lsp.utils")

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
  root_dir = vim.fs.dirname(
    vim.fs.find({ "compile_commands.json", "compile_flags.txt", ".git" }, { upward = true })[1]
  ),
  init_options = {
    usePlaceholders = true,
    completeUnimported = true,
    clangdFileStatus = true,
  },
  capabilities = utils.capabilities,
})
