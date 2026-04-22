return {
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--header-insertion=iwyu",
    "--completion-style=detailed",
    "--function-arg-placeholders=1",
    "--fallback-style=llvm",
  },
  filetypes = { "c", "cpp" },
  root_markers = { "compile_commands.json", "compile_flags.txt", ".git" },
  init_options = {
    usePlaceholders = true,
    completeUnimported = true,
    clangdFileStatus = true,
  },
}
