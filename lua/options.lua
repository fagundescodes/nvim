local o = vim.o

-- vim.g.mapleader = " "

-- UI
o.termguicolors = true
o.title = true
o.titlelen = 70
o.titlestring = "nvim %F %h%m%r%w"
o.laststatus = 3
o.showmode = false

o.guicursor = "n-v-c-i:block"
o.cursorline = true
o.cursorcolumn = true

o.number = true
vim.wo.relativenumber = true
vim.wo.signcolumn = "yes"

o.showbreak = "↪"
o.list = true
vim.opt.listchars:append({
  eol = "↲",
  space = "·",
  tab = "→ ",
  nbsp = "␣",
  extends = "»",
  precedes = "«",
})

o.cmdheight = 1
-- o.background = "dark"

-- Clipboard
o.clipboard = "unnamedplus"

-- File
o.autoread = true
o.undofile = true
o.updatetime = 200

-- Search
o.ignorecase = true
o.smartcase = true
o.hlsearch = true

-- Completion
o.shellslash = true
o.wildmenu = true
o.wildoptions = "pum,tagfile,fuzzy"
o.completeopt = "menu,menuone,noinsert"
o.wildignore = o.wildignore .. ",*/node_modules/*,*/bin/*,*/obj/*,"

-- Indent
o.breakindent = true
o.expandtab = true
o.shiftwidth = 2
o.tabstop = 2
o.softtabstop = 2
o.smartindent = true

-- Fold
o.foldenable = true
o.foldlevel = 99
o.foldlevelstart = 99
o.foldmethod = "expr"
o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
o.foldtext = "v:lua.CustomFoldText()"
vim.opt.foldcolumn = "1"
vim.opt.fillchars:append({ fold = " " })

function _G.CustomFoldText()
  local line = vim.fn.getline(vim.v.foldstart)
  local num_lines = vim.v.foldend - vim.v.foldstart + 1
  return " » " .. line .. " … [" .. num_lines .. " linhas]"
end

-- Behavior
o.timeoutlen = 400
o.winborder = "rounded"
o.mouse = "a"
o.linebreak = true
o.splitbelow = true
o.splitright = true

-- Mason binaries to PATH
local is_windows = vim.loop.os_uname().sysname == "Windows_NT"
vim.env.PATH = vim.env.PATH .. (is_windows and ";" or ":") .. vim.fn.stdpath("data") .. "/mason/bin"

-- Quickfix filter plugin
vim.cmd.packadd("cfilter")
