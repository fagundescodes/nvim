--- Enable bright yellow comments regardless of colorscheme
local M = {}

-- Settings
local opts = {}

---Enable/disable
---@type boolean

opts.enable = false

---Highlight definition
function opts.highlight_setter()
  if vim.o.background == "dark" then
    vim.api.nvim_set_hl(0, "Comment", { fg = "NvimLightYellow" })
  else
    vim.api.nvim_set_hl(0, "Comment", { fg = "NvimDarkGray2", bg = "NvimLightYellow" })
  end
end

-- PRIVATE FIELDS / METHODS

---Prevents enabling twice (overwrites original highlight)
local guard = false

---@type vim.api.keyset.hl_info
local old_hl = vim.api.nvim_get_hl(0, { name = "Comment" })

local group_name = _G.ConfigPrefix .. "Comment"
local group = vim.api.nvim_create_augroup(group_name, { clear = true })

local function enable()
  if guard then
    return
  end
  guard = true

  old_hl = vim.api.nvim_get_hl(0, { name = "Comment" })
  opts.highlight_setter()

  opts.enable = true
end

local function disable()
  vim.api.nvim_set_hl(0, "Comment", { fg = old_hl.fg })
  vim.api.nvim_clear_autocmds({ group = group })
  guard = false
  opts.enable = false
end

-- PUBLIC METHODS

---Highlight comments in bright yellow. Pass `false` to disable.
---@param enabled? boolean
function M.enable(enabled)
  if enabled == false then
    disable()
    return
  end

  vim.api.nvim_create_autocmd("Colorscheme", {
    group = group,
    callback = function()
      guard = false
      enable()
    end,
  })

  enable()
end

---Toggle highlighting comments in bright yellow
function M.toggle()
  M.enable(not opts.enable)
end

-- Enable
M.enable(opts.enable)

-- Expose
_G.Config.HighlightComments = M
