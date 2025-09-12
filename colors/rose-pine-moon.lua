-- Rose Pine Moon color palette
local colors = {
  -- Base colors
  base = "#232136",
  surface = "#2a273f",
  overlay = "#393552",
  muted = "#6e6a86",
  subtle = "#908caa",
  text = "#e0def4",
  love = "#eb6f92",
  gold = "#f6c177",
  rose = "#ea9a97",
  pine = "#3e8fb0",
  foam = "#9ccfd8",
  iris = "#c4a7e7",

  -- Highlight variants
  highlight_low = "#2a283e",
  highlight_med = "#44415a",
  highlight_high = "#56526e",
}

local function set_essential_colors()
  vim.g.colors_name = "rose-pine-moon"

  vim.api.nvim_set_hl(0, "Normal", { fg = colors.text, bg = colors.base })
  vim.api.nvim_set_hl(0, "StatusLine", { fg = colors.text, bg = colors.surface })
  vim.api.nvim_set_hl(0, "StatusLineNC", { fg = colors.muted, bg = colors.surface })
  vim.api.nvim_set_hl(0, "WinBar", { fg = colors.text, bg = colors.surface })
  vim.api.nvim_set_hl(0, "WinBarNC", { fg = colors.muted, bg = colors.surface })
end

local function set_colors()
  vim.g.colors_name = "rose-pine-moon"

  -- Set background
  vim.api.nvim_set_hl(0, "Normal", { fg = colors.text, bg = colors.base })
  vim.api.nvim_set_hl(0, "NormalFloat", { fg = colors.text, bg = colors.surface })

  -- Basic syntax
  vim.api.nvim_set_hl(0, "Comment", { fg = colors.muted, italic = true })
  vim.api.nvim_set_hl(0, "Constant", { fg = colors.gold })
  vim.api.nvim_set_hl(0, "String", { fg = colors.gold })
  vim.api.nvim_set_hl(0, "Character", { fg = colors.gold })
  vim.api.nvim_set_hl(0, "Number", { fg = colors.rose })
  vim.api.nvim_set_hl(0, "Boolean", { fg = colors.rose })
  vim.api.nvim_set_hl(0, "Float", { fg = colors.rose })

  vim.api.nvim_set_hl(0, "Identifier", { fg = colors.text })
  vim.api.nvim_set_hl(0, "Function", { fg = colors.rose })
  vim.api.nvim_set_hl(0, "Statement", { fg = colors.pine })
  vim.api.nvim_set_hl(0, "Conditional", { fg = colors.pine })
  vim.api.nvim_set_hl(0, "Repeat", { fg = colors.pine })
  vim.api.nvim_set_hl(0, "Label", { fg = colors.foam })
  vim.api.nvim_set_hl(0, "Operator", { fg = colors.subtle })
  vim.api.nvim_set_hl(0, "Keyword", { fg = colors.pine })
  vim.api.nvim_set_hl(0, "Exception", { fg = colors.pine })

  vim.api.nvim_set_hl(0, "PreProc", { fg = colors.iris })
  vim.api.nvim_set_hl(0, "Include", { fg = colors.iris })
  vim.api.nvim_set_hl(0, "Define", { fg = colors.iris })
  vim.api.nvim_set_hl(0, "Macro", { fg = colors.iris })
  vim.api.nvim_set_hl(0, "PreCondit", { fg = colors.iris })

  vim.api.nvim_set_hl(0, "Type", { fg = colors.foam })
  vim.api.nvim_set_hl(0, "StorageClass", { fg = colors.foam })
  vim.api.nvim_set_hl(0, "Structure", { fg = colors.foam })
  vim.api.nvim_set_hl(0, "Typedef", { fg = colors.foam })

  vim.api.nvim_set_hl(0, "Special", { fg = colors.rose })
  vim.api.nvim_set_hl(0, "SpecialChar", { fg = colors.gold })
  vim.api.nvim_set_hl(0, "Tag", { fg = colors.foam })
  vim.api.nvim_set_hl(0, "Delimiter", { fg = colors.subtle })
  vim.api.nvim_set_hl(0, "SpecialComment", { fg = colors.muted })
  vim.api.nvim_set_hl(0, "Debug", { fg = colors.rose })

  -- Editor colors
  vim.api.nvim_set_hl(0, "Error", { fg = colors.love })
  vim.api.nvim_set_hl(0, "ErrorMsg", { fg = colors.love })
  vim.api.nvim_set_hl(0, "WarningMsg", { fg = colors.gold })
  vim.api.nvim_set_hl(0, "Todo", { fg = colors.base, bg = colors.gold, bold = true })

  -- UI elements
  vim.api.nvim_set_hl(0, "LineNr", { fg = colors.muted })
  vim.api.nvim_set_hl(0, "CursorLineNr", { fg = colors.text })
  vim.api.nvim_set_hl(0, "CursorLine", { bg = colors.highlight_low })
  vim.api.nvim_set_hl(0, "CursorColumn", { bg = colors.highlight_low })
  vim.api.nvim_set_hl(0, "ColorColumn", { bg = colors.highlight_low })

  vim.api.nvim_set_hl(0, "Visual", { bg = colors.highlight_med })
  vim.api.nvim_set_hl(0, "VisualNOS", { bg = colors.highlight_med })
  vim.api.nvim_set_hl(0, "Search", { fg = colors.base, bg = colors.gold })
  vim.api.nvim_set_hl(0, "IncSearch", { fg = colors.base, bg = colors.rose })
  vim.api.nvim_set_hl(0, "MatchParen", { fg = colors.text, bg = colors.highlight_high })

  -- Status line
  vim.api.nvim_set_hl(0, "StatusLine", { fg = colors.text, bg = colors.surface })
  vim.api.nvim_set_hl(0, "StatusLineNC", { fg = colors.muted, bg = colors.surface })

  -- Winbar
  vim.api.nvim_set_hl(0, "WinBar", { fg = colors.text, bg = colors.surface })
  vim.api.nvim_set_hl(0, "WinBarNC", { fg = colors.muted, bg = colors.surface })

  -- Pmenu
  vim.api.nvim_set_hl(0, "Pmenu", { fg = colors.subtle, bg = colors.surface })
  vim.api.nvim_set_hl(0, "PmenuSel", { fg = colors.text, bg = colors.overlay })
  vim.api.nvim_set_hl(0, "PmenuSbar", { bg = colors.overlay })
  vim.api.nvim_set_hl(0, "PmenuThumb", { bg = colors.muted })

  -- Diagnostics
  vim.api.nvim_set_hl(0, "DiagnosticError", { fg = colors.love })
  vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = colors.gold })
  vim.api.nvim_set_hl(0, "DiagnosticInfo", { fg = colors.foam })
  vim.api.nvim_set_hl(0, "DiagnosticHint", { fg = colors.iris })

  -- Git signs
  vim.api.nvim_set_hl(0, "Added", { fg = colors.foam })
  vim.api.nvim_set_hl(0, "Removed", { fg = colors.love })
  vim.api.nvim_set_hl(0, "Changed", { fg = colors.rose })

  -- Treesitter
  vim.api.nvim_set_hl(0, "@variable", { fg = colors.text })
  vim.api.nvim_set_hl(0, "@variable.builtin", { fg = colors.love })
  vim.api.nvim_set_hl(0, "@variable.parameter", { fg = colors.iris })
  vim.api.nvim_set_hl(0, "@constant", { fg = colors.gold })
  vim.api.nvim_set_hl(0, "@constant.builtin", { fg = colors.love })
  vim.api.nvim_set_hl(0, "@constant.macro", { fg = colors.love })
  vim.api.nvim_set_hl(0, "@module", { fg = colors.text })
  vim.api.nvim_set_hl(0, "@label", { fg = colors.foam })
  vim.api.nvim_set_hl(0, "@string", { fg = colors.gold })
  vim.api.nvim_set_hl(0, "@character", { fg = colors.gold })
  vim.api.nvim_set_hl(0, "@number", { fg = colors.gold })
  vim.api.nvim_set_hl(0, "@boolean", { fg = colors.rose })
  vim.api.nvim_set_hl(0, "@float", { fg = colors.gold })
  vim.api.nvim_set_hl(0, "@function", { fg = colors.rose })
  vim.api.nvim_set_hl(0, "@function.builtin", { fg = colors.love })
  vim.api.nvim_set_hl(0, "@function.macro", { fg = colors.iris })
  vim.api.nvim_set_hl(0, "@method", { fg = colors.rose })
  vim.api.nvim_set_hl(0, "@constructor", { fg = colors.foam })
  vim.api.nvim_set_hl(0, "@parameter", { fg = colors.iris })
  vim.api.nvim_set_hl(0, "@keyword", { fg = colors.pine })
  vim.api.nvim_set_hl(0, "@keyword.function", { fg = colors.pine })
  vim.api.nvim_set_hl(0, "@keyword.return", { fg = colors.pine })
  vim.api.nvim_set_hl(0, "@conditional", { fg = colors.pine })
  vim.api.nvim_set_hl(0, "@repeat", { fg = colors.pine })
  vim.api.nvim_set_hl(0, "@exception", { fg = colors.pine })
  vim.api.nvim_set_hl(0, "@type", { fg = colors.foam })
  vim.api.nvim_set_hl(0, "@type.builtin", { fg = colors.love })
  vim.api.nvim_set_hl(0, "@attribute", { fg = colors.iris })
  vim.api.nvim_set_hl(0, "@property", { fg = colors.iris })
  vim.api.nvim_set_hl(0, "@field", { fg = colors.iris })
  vim.api.nvim_set_hl(0, "@namespace", { fg = colors.text })
  vim.api.nvim_set_hl(0, "@symbol", { fg = colors.text })
  vim.api.nvim_set_hl(0, "@text", { fg = colors.text })
  vim.api.nvim_set_hl(0, "@text.strong", { fg = colors.iris, bold = true })
  vim.api.nvim_set_hl(0, "@text.emphasis", { fg = colors.iris, italic = true })
  vim.api.nvim_set_hl(0, "@text.uri", { fg = colors.iris, underline = true })
  vim.api.nvim_set_hl(0, "@tag", { fg = colors.foam })
  vim.api.nvim_set_hl(0, "@tag.attribute", { fg = colors.iris })
  vim.api.nvim_set_hl(0, "@tag.delimiter", { fg = colors.subtle })

  -- LSP semantic tokens
  vim.api.nvim_set_hl(0, "@lsp.type.class", { fg = colors.foam })
  vim.api.nvim_set_hl(0, "@lsp.type.decorator", { fg = colors.iris })
  vim.api.nvim_set_hl(0, "@lsp.type.enum", { fg = colors.foam })
  vim.api.nvim_set_hl(0, "@lsp.type.enumMember", { fg = colors.gold })
  vim.api.nvim_set_hl(0, "@lsp.type.function", { fg = colors.rose })
  vim.api.nvim_set_hl(0, "@lsp.type.interface", { fg = colors.foam })
  vim.api.nvim_set_hl(0, "@lsp.type.macro", { fg = colors.iris })
  vim.api.nvim_set_hl(0, "@lsp.type.method", { fg = colors.rose })
  vim.api.nvim_set_hl(0, "@lsp.type.namespace", { fg = colors.text })
  vim.api.nvim_set_hl(0, "@lsp.type.parameter", { fg = colors.iris })
  vim.api.nvim_set_hl(0, "@lsp.type.property", { fg = colors.iris })
  vim.api.nvim_set_hl(0, "@lsp.type.struct", { fg = colors.foam })
  vim.api.nvim_set_hl(0, "@lsp.type.type", { fg = colors.foam })
  vim.api.nvim_set_hl(0, "@lsp.type.typeParameter", { fg = colors.foam })
  vim.api.nvim_set_hl(0, "@lsp.type.variable", { fg = colors.text })

  -- Whitespace characters
  vim.api.nvim_set_hl(0, "Whitespace", { fg = colors.highlight_high })
  vim.api.nvim_set_hl(0, "NonText", { fg = colors.highlight_high })
  vim.api.nvim_set_hl(0, "EndOfBuffer", { fg = colors.highlight_high })
  vim.api.nvim_set_hl(0, "SpecialKey", { fg = colors.highlight_high })

  -- Terminal colors
  vim.g.terminal_color_0 = colors.overlay
  vim.g.terminal_color_1 = colors.love
  vim.g.terminal_color_2 = colors.pine
  vim.g.terminal_color_3 = colors.gold
  vim.g.terminal_color_4 = colors.foam
  vim.g.terminal_color_5 = colors.iris
  vim.g.terminal_color_6 = colors.rose
  vim.g.terminal_color_7 = colors.text
  vim.g.terminal_color_8 = colors.muted
  vim.g.terminal_color_9 = colors.love
  vim.g.terminal_color_10 = colors.pine
  vim.g.terminal_color_11 = colors.gold
  vim.g.terminal_color_12 = colors.foam
  vim.g.terminal_color_13 = colors.iris
  vim.g.terminal_color_14 = colors.rose
  vim.g.terminal_color_15 = colors.text

  -- Statusline colors
  vim.api.nvim_set_hl(0, "StatusLineGreen", { fg = colors.surface, bg = colors.pine })
  vim.api.nvim_set_hl(0, "StatusLineYellow", { fg = colors.surface, bg = colors.gold })
  vim.api.nvim_set_hl(0, "StatusLineRed", { fg = colors.surface, bg = colors.love })
  vim.api.nvim_set_hl(0, "StatusLineBlue", { fg = colors.surface, bg = colors.foam })
  vim.api.nvim_set_hl(0, "StatusLineCyan", { fg = colors.surface, bg = colors.foam })

  -- Winbar colors
  vim.api.nvim_set_hl(0, "WinBarGreen", { fg = colors.pine, bg = colors.surface })
  vim.api.nvim_set_hl(0, "WinBarYellow", { fg = colors.gold, bg = colors.surface })
  vim.api.nvim_set_hl(0, "WinBarRed", { fg = colors.love, bg = colors.surface })
  vim.api.nvim_set_hl(0, "WinBarBlue", { fg = colors.foam, bg = colors.surface })
  vim.api.nvim_set_hl(0, "WinBarCyan", { fg = colors.foam, bg = colors.surface })

  -- Fold highlights
  vim.api.nvim_set_hl(0, "Folded", { fg = colors.muted, bg = colors.surface })
  vim.api.nvim_set_hl(0, "FoldColumn", { fg = colors.muted, bg = colors.base })
end

set_essential_colors()

vim.schedule(set_colors)
