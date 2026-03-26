local utils = require("lsp.utils")
local lsp = require("lsp.helpers")
local format = require("format.helpers")

local root_files = {
  "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt",
  "Pipfile", "poetry.lock", "pyrightconfig.json", ".git"
}
local root_dir = lsp.find_root(root_files)

if root_dir then
  vim.lsp.start({
    name = "basedpyright",
    cmd = { "basedpyright-langserver", "--stdio" },
    filetypes = { "python" },
    root_dir = root_dir,
    capabilities = utils.capabilities,
    settings = {
      basedpyright = {
        analysis = {
          typeCheckingMode = "basic",
          autoSearchPaths = true,
          diagnosticMode = "openFilesOnly",
          exclude = { "**/migrations", "**/__pycache__", "**/node_modules" },
          diagnosticSeverityOverrides = {
            reportMissingImports = "error",
            reportUndefinedVariable = "error",
            reportMissingTypeStubs = "none",
            reportAssignmentType = "none",
            reportAttributeAccessIssue = "none",
            reportGeneralTypeIssues = "none",
            reportArgumentType = "none",
          },
        },
      },
    },
  })
end

if vim.fn.executable("isort") == 1 and vim.fn.executable("black") == 1 then
  vim.keymap.set("n", "<leader>fm", function()
    format.run_file_commands({
      { "isort" },
      { "black" },
    })
  end, { buffer = true, desc = "Format Python file" })
end

vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.expandtab = true
vim.opt_local.smartindent = true
