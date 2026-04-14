return {
  -- lua/plugins/rose-pine.lua
  {
    "rose-pine/neovim",
    name = "rose-pine",
    config = function()
      vim.cmd("colorscheme rose-pine")
    end
  },

  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = function()
      return require("plugins.configs.nvim-tree")
    end,
    config = function(_, opts)
      require("nvim-tree").setup(opts)
    end,
  },

  -- Syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("plugins.configs.treesitter")
    end,
  },

  -- Comp
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "rafamadriz/friendly-snippets",
      {
        "L3MON4D3/LuaSnip",
        opts = { history = true, updateevents = "TextChanged,TextChangedI" },
        config = function()
          require("luasnip").config.set_config({ history = true, updateevents = "TextChanged,TextChangedI" })
          require("luasnip.loaders.from_vscode").lazy_load()
        end,
      },
      -- cmp sources
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
    config = function()
      require("plugins.configs.cmp")
    end,
  },

  -- File finder
  {
    "ibhagwan/fzf-lua",
    cmd = { "FzfLua" },
    config = function()
      require("plugins.configs.fzf")
    end,
  },

  -- Git signs
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = function()
      return require("plugins.configs.gitsigns")
    end,
  },

  -- DAP
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      require("plugins.configs.dap")
    end,
  },

  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = {
      "mfussenegger/nvim-dap",
      "rcarriga/nvim-dap-ui",
    },
    config = function()
      local path = vim.fn.exepath("python")
      require("dap-python").setup(path)
      local dap = require("dap")
      if dap.configurations.python then
        for _, cfg in ipairs(dap.configurations.python) do
          cfg.justMyCode = false
        end
      end
    end,
  },

  {
    "leoluz/nvim-dap-go",
    ft = "go",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      require("dap-go").setup({
        delve = {
          args = { "--check-go-version=false" },
        },
      })
    end,
  },

  -- Java LSP/DAP
  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
    dependencies = { "mfussenegger/nvim-dap" },
  },
}
