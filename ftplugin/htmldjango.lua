vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.expandtab = true
vim.opt_local.commentstring = "{# %s #}"

local djlint = vim.fn.exepath("djlint")
if djlint ~= "" then
  vim.keymap.set("n", "<leader>fm", function()
    local file = vim.fn.expand("%:p")
    local escaped_file = vim.fn.shellescape(file)
    local cursor_pos = vim.api.nvim_win_get_cursor(0)

    vim.cmd("write")
    vim.fn.system("djlint --reformat " .. escaped_file)
    vim.cmd("checktime")
    vim.api.nvim_win_set_cursor(0, cursor_pos)
  end, { buffer = true, desc = "Format Django template" })
end
