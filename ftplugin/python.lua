local utils = require("lsp.utils")

local root_files = {
  "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt",
  "Pipfile", "poetry.lock", "pyrightconfig.json", ".git"
}
local paths = vim.fs.find(root_files, { stop = vim.env.HOME })
local root_dir = paths[1] and vim.fs.dirname(paths[1]) or vim.fn.getcwd()

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
    on_attach = function(client, bufnr)
      utils.on_attach(client, bufnr)

      vim.keymap.set("n", "<leader>fm", function()
        local file = vim.fn.expand("%")
        local escaped_file = vim.fn.shellescape(file)
        local cursor_pos  = vim.api.nvim_win_get_cursor(0)

        vim.cmd("write")

        vim.fn.system("isort " .. escaped_file)
        vim.fn.system("black " .. escaped_file)

        vim.cmd("checktime")
        vim.api.nvim_win_set_cursor(0, cursor_pos)
      end, { buffer = bufnr, desc = "Format Python file" })
    end,
  })
end

vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.expandtab = true
vim.opt_local.smartindent = true
