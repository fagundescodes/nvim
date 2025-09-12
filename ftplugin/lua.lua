local utils = require("lsp.utils")

vim.lsp.start({
  name = "lua_ls",
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_dir = vim.fs.dirname(
    vim.fs.find(
      { ".luarc.json", ".luarc.jsonc", ".luacheckrc", "stylua.toml", ".stylua.toml", ".git" },
      { upward = true }
    )[1]
  ),
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = {
          vim.fn.expand("$VIMRUNTIME/lua"),
          vim.fn.expand("$VIMRUNTIME/lua/vim/lsp"),
        },
        maxPreload = 100000,
        preloadFileSize = 10000,
      },
    },
  },
  capabilities = utils.capabilities,
  on_attach = function(client, bufnr)
    utils.on_attach(client, bufnr)
    --format
    vim.keymap.set({ "n" }, "<leader>fm", function()
      vim.lsp.buf.format({
        async = true,
        filter = function(c)
          return c.name == "lua_ls"
        end,
      })
    end)
  end,
})
