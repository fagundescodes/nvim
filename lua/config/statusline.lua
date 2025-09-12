local git = require("utils.git")

local M = {}

local function get_relative_path()
  local filename = vim.fn.expand("%:t")
  if filename == "" then
    return "No Name"
  end
  return filename
end

local function get_git_info()
  local branch = git.branch.get()
  if branch:len() == 0 then
    return ""
  end

  local changes = ""
  if vim.b.gitsigns_status then
    local status = vim.b.gitsigns_status
    if status and status ~= "" then
      changes = " " .. status
    end
  end

  return "[󰘬 " .. branch .. changes .. "]"
end

function M.statusline()
  local parts = {}

  local filepath = get_relative_path()
  table.insert(parts, "[" .. filepath .. "]")

  local indicators = {}
  if vim.bo.modified then
    table.insert(indicators, "[+]")
  end
  if vim.bo.readonly then
    table.insert(indicators, "[RO]")
  end
  if #indicators > 0 then
    table.insert(parts, " " .. table.concat(indicators, " "))
  end

  local git_info = get_git_info()
  if git_info ~= "" then
    table.insert(parts, " " .. git_info)
  end

  table.insert(parts, "%=")

  if vim.diagnostic then
    local errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    local warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
    if errors > 0 or warnings > 0 then
      local diag_parts = {}
      if errors > 0 then
        table.insert(diag_parts, "E:" .. errors)
      end
      if warnings > 0 then
        table.insert(diag_parts, "W:" .. warnings)
      end
      table.insert(parts, " " .. table.concat(diag_parts, " ") .. " ")
    end
  end

  if vim.bo.filetype ~= "" then
    table.insert(parts, " [" .. vim.bo.filetype .. "]")
  end

  table.insert(parts, " [%l:%c %p%%] ")

  return table.concat(parts)
end

function M.winbar()
  local parts = {}

  table.insert(parts, "[" .. vim.fn.bufnr() .. "]: ")

  -- Caminho completo do arquivo
  local filepath = vim.fn.expand("%:p")
  if filepath == "" then
    table.insert(parts, "No Name")
  else
    table.insert(parts, vim.fn.expand("%:f"))
  end

  -- File indicators
  if vim.bo.modified then
    table.insert(parts, " [+]")
  end
  if vim.bo.readonly then
    table.insert(parts, " [RO]")
  end

  return table.concat(parts)
end

function M.setup()
  vim.opt.statusline = "%!v:lua.require('config.statusline').statusline()"
  vim.opt.winbar = "%!v:lua.require('config.statusline').winbar()"
end

M.setup()

return M
