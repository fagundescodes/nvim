-- Sync clipboard between OS and Neovim.
vim.o.clipboard = "unnamedplus"

-- file opts
vim.o.autoread = true
vim.o.undofile = true
vim.o.updatetime = 200

-- search settings
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.hlsearch = true

-- completion settings
vim.o.shellslash = true
vim.o.wildmenu = true
vim.o.wildoptions = "pum,tagfile,fuzzy"
vim.o.completeopt = "menu,menuone,noinsert"
vim.o.wildignore = vim.o.wildignore .. ",*/node_modules/*,*/bin/*,*/obj/*,"

-- indent options
vim.o.breakindent = true
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2

-- -- fold options

vim.o.foldenable = true
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
-- vim.o.foldtext = ""
vim.opt.foldcolumn = "1"
vim.opt.fillchars:append({ fold = " " })

vim.o.foldtext = "v:lua.CustomFoldText()"

function _G.CustomFoldText()
  local line = vim.fn.getline(vim.v.foldstart)
  local num_lines = vim.v.foldend - vim.v.foldstart + 1
  return " » " .. line .. " … [" .. num_lines .. " linhas]"
end

-- keymap behavior
vim.o.timeoutlen = 400
vim.o.winborder = "rounded"

-- enable mouse
vim.o.mouse = "a"

-- wrap behavior
vim.o.linebreak = true

-- window behavior
vim.o.splitbelow = true
vim.o.splitright = true

-- qflist filter
vim.cmd.packadd("cfilter")
