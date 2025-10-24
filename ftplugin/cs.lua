local utils = require("lsp.utils")

local root_files = {
  "*.sln", "*.csproj", "omnisharp.json", "function.json", ".git"
}
local paths = vim.fs.find(root_files, { stop = vim.env.HOME })
local root_dir = paths[1] and vim.fs.dirname(paths[1]) or vim.fn.getcwd()

if root_dir then
  vim.lsp.start({
    name = "csharp_ls",
    cmd = { "csharp-ls" },
    filetypes = { "cs" },
    root_dir = root_dir,
    capabilities = utils.capabilities,
    init_options = {
      AutomaticWorkspaceInit = true,
    },
    on_attach = function(client, bufnr)
      utils.on_attach(client, bufnr)

      vim.keymap.set("n", "<leader>fm", function()
        vim.lsp.buf.format({ async = false })
      end, { buffer = bufnr, desc = "Format C# file" })
    end,
  })
end

vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.expandtab = true
vim.opt_local.smartindent = true
