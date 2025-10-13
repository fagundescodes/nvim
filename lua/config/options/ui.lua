-- better colors
vim.o.termguicolors = true

-- ui elements
vim.o.title = true
vim.o.titlelen = 70
vim.o.titlestring = "nvim %F %h%m%r%w"
vim.o.laststatus = 3

-- cursor
vim.o.guicursor = "n-v-c-i:block"
-- vim.o.colorcolumn = "80"
vim.o.cursorline = true
vim.o.cursorcolumn = true

-- gutter
vim.wo.number = true
vim.wo.relativenumber = true
vim.wo.signcolumn = "yes"

-- white space characters
vim.o.showbreak = "↪"
vim.o.list = true
vim.opt.listchars:append({
  -- New line
  eol = "↲",

  -- Spaces
  space = "·",
  tab = "→ ",
  nbsp = "␣",

  -- Others
  extends = "»",
  precedes = "«",
})

-- cmdline height
-- not a fan of `messagesopt=wait:{n}`
vim.o.cmdheight = 1

-- background setting
vim.o.background = "dark"

vim.cmd("colorscheme rose-pine")

-- vim.api.nvim_create_autocmd("ColorScheme", {
--   callback = function()
--     vim.api.nvim_set_hl(0, "Whitespace", { fg = "#524f67" })
--     vim.api.nvim_set_hl(0, "NonText", { fg = "#524f67" })
--     vim.api.nvim_set_hl(0, "SpecialKey", { fg = "#524f67" })
--   end,
-- })
--
-- vim.api.nvim_set_hl(0, "Whitespace", { fg = "#524f67" })
-- vim.api.nvim_set_hl(0, "NonText", { fg = "#524f67" })
-- vim.api.nvim_set_hl(0, "SpecialKey", { fg = "#524f67" })
