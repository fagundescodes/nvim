local utils = require "lsp.utils"

local root_files = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", ".git" }
local paths = vim.fs.find(root_files, { stop = vim.env.HOME })
local root_dir = paths[1] and vim.fs.dirname(paths[1]) or vim.fn.getcwd()

if root_dir then
  vim.lsp.start {
    name = "jedi",
    cmd = { "jedi-language-server" },
    filetypes = { "python" },
    root_dir = root_dir,
    capabilities = utils.capabilities,
    settings = {
      jedi = {
        diagnostics = {
          enable = true,
          didOpen = true,
          didChange = true,
          didSave = true,
        },
        hover = {
          enable = true,
        },
        completion = {
          disableSnippets = false,
          resolveEagerly = false,
          includeParams = true,
        },
      },
    },
    on_attach = function(client, bufnr)
      utils.on_attach(client, bufnr)

      vim.keymap.set({ "n" }, "<leader>fm", function()
        vim.cmd "write"
        vim.fn.system("black " .. vim.fn.shellescape(vim.fn.expand "%"))
        vim.cmd "edit!"
      end, { buffer = bufnr })
    end,
  }
end
