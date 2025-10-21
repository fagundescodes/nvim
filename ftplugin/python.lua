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
          typeCheckingMode = "standard",
          autoSearchPaths = true,
          useLibraryCodeForTypes = true,
          autoImportCompletions = true,
          diagnosticMode = "workspace",
          strictListInference = true,
          strictDictionaryInference = true,
          strictSetInference = true,
          reportMissingImports = true,
          reportMissingTypeStubs = false,
          reportUndefinedVariable = true,
          reportAssertAlwaysTrue = "warning",
          reportConstantRedefinition = "error",
          reportDuplicateImport = "warning",
          reportFunctionMemberAccess = "warning",
          reportIncompatibleMethodOverride = "warning",
          reportIncompatibleVariableOverride = "warning",
          reportIncompleteStub = "warning",
          reportInconsistentConstructor = "warning",
          reportInvalidStringEscapeSequence = "warning",
          reportMissingParameterType = "warning",
          reportMissingTypeArgument = "warning",
          reportOptionalCall = "warning",
          reportOptionalContextManager = "warning",
          reportOptionalIterable = "warning",
          reportOptionalMemberAccess = "warning",
          reportOptionalOperand = "warning",
          reportOptionalSubscript = "warning",
          reportPrivateImportUsage = "warning",
          reportSelfClsParameterName = "warning",
          reportTypeCommentUsage = "warning",
          reportUnknownArgumentType = "warning",
          reportUnknownLambdaType = "warning",
          reportUnknownMemberType = "warning",
          reportUnknownParameterType = "warning",
          reportUnknownVariableType = "warning",
          reportUnnecessaryCast = "warning",
          reportUnnecessaryComparison = "warning",
          reportUnnecessaryContains = "warning",
          reportUnnecessaryIsInstance = "warning",
          reportUnusedClass = "warning",
          reportUnusedFunction = "warning",
          reportUnusedImport = "warning",
          reportUnusedVariable = "warning",
          pythonVersion = "3.11",
          pythonPlatform = "Linux",
          venvPath = ".",
          venv = ".venv",
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
