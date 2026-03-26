local utils = require("lsp.utils")
local lsp = require("lsp.helpers")

vim.lsp.start({
  name = "lua_ls",
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_dir = lsp.find_root({ ".luarc.json", ".luarc.jsonc", ".luacheckrc", "stylua.toml", ".stylua.toml", ".git" }),
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
})
