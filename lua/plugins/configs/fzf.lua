local fzf = require("fzf-lua")
fzf.setup({
  winopts = {
    preview = {
      layout = "vertical",
    },
  },
  files = {
    respect_gitignore = true,
    hidden = false,
    follow_symlinks = true,
  },
  keymap = {
    builtin = {
      ["<C-u>"] = "preview-page-up",
      ["<C-d>"] = "preview-page-down",
    },
    fzf = {
      ["ctrl-q"] = "abort",
      ["ctrl-u"] = "preview-half-page-up",
      ["ctrl-d"] = "preview-half-page-down",
    },
  },
  fzf_opts = {
    ["--layout"] = "default",
    ["--info"] = "default",
  },
  actions = {
    files = {
      ["default"] = fzf.actions.file_edit,
      ["ctrl-g"] = fzf.actions.toggle_ignore,
      ["ctrl-h"] = fzf.actions.toggle_hidden,
    },
  },
})
return fzf

