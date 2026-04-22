return {
  cmd = { "basedpyright-langserver", "--stdio" },
  filetypes = { "python" },
  root_markers = {
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    "Pipfile",
    "poetry.lock",
    "pyrightconfig.json",
    ".git",
  },
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
}
