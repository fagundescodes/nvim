local format = require("format.helpers")
local bufnr = vim.api.nvim_get_current_buf()

if vim.fn.executable("isort") == 1 and vim.fn.executable("black") == 1 then
  format.set_buffer_formatter(bufnr, function()
    format.run_file_commands({
      { "isort" },
      { "black" },
    }, bufnr)
  end)
end

vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.expandtab = true
vim.opt_local.smartindent = true
