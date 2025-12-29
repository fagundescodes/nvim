local utils = require("lsp.utils")

vim.lsp.start({
  name = "ts_ls",
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = { "vue" },
  root_dir = vim.fs.dirname(
    vim.fs.find({ "package.json", "tsconfig.json", "jsconfig.json", ".git" }, { upward = true })[1]
  ),
  init_options = {
    hostInfo = "neovim",
    plugins = {
      {
        name = "@vue/typescript-plugin",
        location = "/usr/lib/node_modules/@vue/language-server/node_modules/@vue/typescript-plugin",
        languages = { "vue" },
      },
    },
  },
  capabilities = utils.capabilities,
  on_attach = utils.on_attach,
})

vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.expandtab = true

vim.keymap.set("n", "<leader>fm", function()
  local prettier = vim.fn.getcwd() .. "/node_modules/.bin/prettier"
  if vim.fn.executable(prettier) == 0 then
    vim.notify("Prettier not found in node_modules", vim.log.levels.ERROR)
    return
  end

  local bufnr = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local input = table.concat(lines, "\n")

  local result = vim.system(
    { prettier, "--stdin-filepath", vim.fn.expand("%:p") },
    { stdin = input, text = true }
  ):wait()

  if result.code == 0 then
    local output = vim.split(result.stdout, "\n")
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, output)
  else
    vim.notify("Prettier failed: " .. (result.stderr or "unknown error"), vim.log.levels.ERROR)
  end
end, { buffer = true, desc = "Format with Prettier" })
