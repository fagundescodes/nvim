local ts = require("nvim-treesitter")

local parsers = {
  -- defaults
  "vim",
  "lua",
  "vimdoc",

  -- web dev
  "html",
  "css",
  "javascript",
  "typescript",
  "tsx",

  -- low level
  "c",
  "zig",
  "rust",
  "cpp",

  -- others
  "python",
  "json",
  "yaml",
  "toml",
  "bash",
  "go",
  "java",
  "regex",
  "c_sharp",
  "sql",
  "query",
}

ts.setup({})

local group = vim.api.nvim_create_augroup("TreesitterSetup", { clear = true })
local install_requested = false

local function install_parsers()
  if install_requested then
    return
  end

  install_requested = true

  vim.schedule(function()
    local ok, err = pcall(ts.install, parsers, { max_jobs = 8 })
    if not ok then
      vim.notify("Treesitter install error: " .. tostring(err), vim.log.levels.WARN)
    end
  end)
end

vim.api.nvim_create_autocmd("User", {
  group = group,
  pattern = "LazyDone",
  once = true,
  desc = "Install treesitter parsers",
  callback = install_parsers,
})

vim.api.nvim_create_autocmd("VimEnter", {
  group = group,
  once = true,
  desc = "Fallback treesitter parser install",
  callback = install_parsers,
})

local ignore_filetypes = {
  checkhealth = true,
  help = true,
  lazy = true,
  mason = true,
  qf = true,
}

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  desc = "Enable treesitter highlight and indent",
  callback = function(event)
    if ignore_filetypes[event.match] then
      return
    end

    pcall(vim.treesitter.start, event.buf)

    local ok, indentexpr = pcall(function()
      return "v:lua.require'nvim-treesitter'.indentexpr()"
    end)
    if ok then
      vim.bo[event.buf].indentexpr = indentexpr
    end
  end,
})
