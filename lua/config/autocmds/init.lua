_G.Config = {}
_G.ConfigPrefix = "Config"
vim.api.nvim_exec = vim.api.nvim_exec2

require("config.autocmds.transparency")
require("config.autocmds.gitsigns")
require("config.autocmds.lazyvim")
require("config.autocmds.templates")
