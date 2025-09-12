local M = {}

local opts = { enable = false }
local guard = false
local old_hl = {}

local group_name = "TransparencyGroup"
local group = vim.api.nvim_create_augroup(group_name, { clear = true })

local function enable()
  if guard then
    return
  end
  guard = true

  -- salva highlight antigo
  old_hl = vim.api.nvim_get_hl(0, { name = "Normal" })
  vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
  opts.enable = true
end

local function disable()
  if old_hl.bg then
    vim.api.nvim_set_hl(0, "Normal", { bg = old_hl.bg })
  else
    vim.api.nvim_set_hl(0, "Normal", { bg = nil })
  end
  vim.api.nvim_clear_autocmds({ group = group })
  guard = false
  opts.enable = false
end

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

function M.toggle()
  M.enable(not opts.enable)
end

-- Enable
M.enable(opts.enable)

-- Expose global
_G.Config = _G.Config or {}
_G.Config.TransparentBackground = M

-- :Transparent
vim.api.nvim_create_user_command("Transparent", function()
  _G.Config.TransparentBackground.toggle()
end, { desc = "Toggle transparent background" })

return M
