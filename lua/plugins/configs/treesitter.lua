local ts = require("nvim-treesitter")

local group = vim.api.nvim_create_augroup("TreesitterSetup", { clear = true })

vim.api.nvim_create_autocmd("User", {
  group = group,
  pattern = "LazyDone",
  once = true,
  desc = "Install treesitter parsers",
  callback = function()
    ts.install({
      "vim",
      "lua",
      "vimdoc",
      "luadoc",
      "html",
      "css",
      "javascript",
      "typescript",
      "tsx",
      "vue",
      "c",
      "zig",
      "rust",
      "cpp",
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
      "markdown",
      "markdown_inline",
    }, { max_jobs = 8 })
  end,
})

local ignore_filetypes = {
  checkhealth = true,
  lazy = true,
  mason = true,
  help = true,
  qf = true,
}

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  desc = "Enable treesitter highlighting",
  callback = function(event)
    if ignore_filetypes[event.match] then
      return
    end

    pcall(vim.treesitter.start, event.buf)
  end,
})
