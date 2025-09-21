local utils = require("lsp.utils")

-- Setup diagnostics globally
utils.setup_diagnostics()

-- Global LspAttach autocmd
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local bufnr = args.buf

    utils.on_attach(client, bufnr)
  end,
})
