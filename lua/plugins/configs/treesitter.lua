require("nvim-treesitter.configs").setup({
  ensure_installed = {
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
    "jsonc",
    "bash",
    "go",
    "java",
    "regex",
    "c_sharp",
    "sql",
    "markdown",
    "markdown_inline",
  },

  highlight = {
    enable = true,
    use_languagetree = true,
    additional_vim_regex_highlighting = false,
  },
  folding = {
    enable = true,
  },
  indent = { enable = true },
})

