-- GNU GLOBAL (gtags) integration for Neovim
-- Lua port of gtags.vim maintaining full compatibility

local M = {}

-- Configuration variables
local config = {
  global_command = vim.env.GTAGSGLOBAL or "global",
  open_quickfix_window = vim.g.Gtags_OpenQuickfixWindow or 1,
  vertical_window = vim.g.Gtags_VerticalWindow or 0,
  auto_map = vim.g.Gtags_Auto_Map or 0,
  auto_update = vim.g.Gtags_Auto_Update or 0,
  emacs_like_mode = vim.g.Gtags_Emacs_Like_Mode or 0,
  no_auto_jump = vim.g.Gtags_No_Auto_Jump or 0,
  close_when_single = vim.g.Gtags_Close_When_Single or 0,
  result = vim.g.Gtags_Result or "ctags-mod",
  efm = vim.g.Gtags_Efm or "%f\t%l\t%m",
  shell_quote_char = vim.g.Gtags_Shell_Quote_Char or (vim.fn.has("win32") == 1 and '"' or "'"),
  single_quote_char = vim.g.Gtags_Single_Quote_Char or "'",
  double_quote_char = vim.g.Gtags_Double_Quote_Char or '"',
}

-- Helper function to display errors
local function error_msg(msg)
  vim.cmd("echohl WarningMsg")
  vim.cmd("echomsg 'Error: " .. msg .. "'")
  vim.cmd("echohl None")
end

-- Extract pattern or option from command line
local function extract(line, target)
  local option = ""
  local pattern = ""
  local force_pattern = false
  local length = #line
  local i = 1

  -- Skip command name
  if line:match("^Gtags") then
    i = 6
  end

  -- Skip leading spaces
  while i <= length and line:sub(i, i) == " " do
    i = i + 1
  end

  while i <= length do
    if line:sub(i, i) == "-" and not force_pattern then
      i = i + 1
      -- Ignore long options like --help
      if i <= length and line:sub(i, i) == "-" then
        while i <= length and line:sub(i, i) ~= " " do
          i = i + 1
        end
      else
        local c = ""
        while i <= length and line:sub(i, i) ~= " " do
          c = line:sub(i, i)
          option = option .. c
          i = i + 1
        end
        if c == "e" then
          force_pattern = true
        end
      end
    else
      pattern = ""
      -- Allow pattern to include blanks
      while i <= length do
        local char = line:sub(i, i)
        if char == "'" then
          pattern = pattern .. config.single_quote_char
        elseif char == '"' then
          pattern = pattern .. config.double_quote_char
        else
          pattern = pattern .. char
        end
        i = i + 1
      end
      if target == "pattern" then
        return pattern
      end
    end
    -- Skip blanks
    while i <= length and line:sub(i, i) == " " do
      i = i + 1
    end
  end

  if target == "option" then
    return option
  end
  return ""
end

-- Trim problematic options
local function trim_option(option)
  local result = ""
  for i = 1, #option do
    local c = option:sub(i, i)
    if not c:match("[cenpquv]") then
      result = result .. c
    end
  end
  return result
end

-- Get global command string
local function global_command(...)
  local result = ""
  local option = ""
  if select("#", ...) > 0 then
    option = " " .. select(1, ...)
  end

  if config.emacs_like_mode == 1 and vim.fn.expand("%") ~= "" then
    result = "cd " .. vim.fn.shellescape(vim.fn.expand("%:p:h")) .. " && " .. config.global_command .. option
  else
    result = config.global_command .. option
  end
  return result
end

-- Execute global and load results into quickfix
local function exec_load(option, long_option, pattern, flags)
  local isfile = false
  local cmd_option = ""
  local result = ""

  if option:find("f") then
    isfile = true
    if vim.fn.filereadable(pattern) == 0 then
      error_msg("File " .. pattern .. " not found.")
      return
    end
  end

  if long_option ~= "" then
    cmd_option = long_option .. " "
  end

  cmd_option = cmd_option .. "--result=" .. config.result .. " -q"
  cmd_option = cmd_option .. trim_option(option)

  local cmd
  if isfile then
    cmd = global_command("--path-style=absolute")
      .. " "
      .. cmd_option
      .. " "
      .. config.shell_quote_char
      .. pattern
      .. config.shell_quote_char
  else
    cmd = global_command("--path-style=absolute")
      .. " "
      .. cmd_option
      .. "e "
      .. config.shell_quote_char
      .. pattern
      .. config.shell_quote_char
  end

  result = vim.fn.system(cmd)

  if vim.v.shell_error ~= 0 then
    if vim.v.shell_error == 2 then
      error_msg("invalid arguments. please use the latest GLOBAL.")
    elseif vim.v.shell_error == 3 then
      error_msg("GTAGS not found.")
    else
      error_msg("global command failed. command line: " .. cmd)
    end
    return
  end

  if result == "" then
    if option:find("f") then
      error_msg("Tag not found in " .. pattern .. ".")
    elseif option:find("P") then
      error_msg("Path which matches to " .. pattern .. " not found.")
    elseif option:find("g") then
      error_msg("Line which matches to " .. pattern .. " not found.")
    else
      error_msg(
        "Tag which matches to " .. config.shell_quote_char .. pattern .. config.shell_quote_char .. " not found."
      )
    end
    return
  end

  -- Open quickfix window
  if config.open_quickfix_window == 1 then
    local should_open = true
    if config.close_when_single == 1 then
      should_open = false
      local first_newline = result:find("\n")
      if first_newline and result:find("\n", first_newline + 1) then
        should_open = true
      end
    end

    if not should_open then
      vim.cmd("cclose")
    elseif config.vertical_window == 1 then
      vim.cmd("topleft vertical copen")
    else
      vim.cmd("botright copen")
    end
  end

  -- Parse output and show in quickfix
  local efm_org = vim.o.errorformat
  vim.o.errorformat = config.efm

  if flags:find("a") then
    vim.cmd("cadde " .. vim.fn.fnameescape(result)) -- append mode
  elseif config.no_auto_jump == 1 then
    vim.cmd("cgete " .. vim.fn.fnameescape(result)) -- does not jump
  else
    vim.cmd("cexpr " .. vim.fn.fnameescape(result)) -- jump
  end

  vim.o.errorformat = efm_org
end

-- Main function to run global
local function run_global(line, flags)
  local pattern = extract(line, "pattern")

  if pattern == "%" then
    pattern = vim.fn.expand("%")
  elseif pattern == "#" then
    pattern = vim.fn.expand("#")
  end

  local option = extract(line, "option")

  -- Get pattern from user if not provided
  if pattern == "" then
    local prompt, default, completion
    if option:find("f") then
      prompt = "Gtags for file: "
      default = vim.fn.expand("%")
      completion = "file"
    else
      prompt = "Gtags for pattern: "
      default = vim.fn.expand("<cword>")
      completion = nil -- Custom completion would need more work
    end

    pattern = vim.fn.input(prompt, default, completion)
    if pattern == "" then
      error_msg("Pattern not specified.")
      return
    end
  end

  exec_load(option, "", pattern, flags)
end

-- Execute from current cursor position
local function gtags_cursor()
  local pattern = vim.fn.expand("<cword>")
  local option = '--from-here="' .. vim.fn.line(".") .. ":" .. vim.fn.expand("%") .. '"'
  exec_load("", option, pattern, "")
end

-- Show current position in browser
local function gozilla()
  local lineno = vim.fn.line(".")
  local filename = vim.fn.expand("%")
  local gozilla_cmd

  if config.emacs_like_mode == 1 and vim.fn.expand("%") ~= "" then
    gozilla_cmd = "cd " .. vim.fn.shellescape(vim.fn.expand("%:p:h")) .. " && gozilla"
  else
    gozilla_cmd = "gozilla"
  end

  vim.fn.system(gozilla_cmd .. " +" .. lineno .. " " .. filename)
end

-- Auto update tag files
local function gtags_auto_update()
  vim.fn.system(global_command() .. ' -u --single-update="' .. vim.fn.expand("%") .. '"')
end

-- Setup function
function M.setup(opts)
  opts = opts or {}

  -- Override config with user options
  for k, v in pairs(opts) do
    if config[k] ~= nil then
      config[k] = v
    end
  end

  -- Define commands
  vim.api.nvim_create_user_command("Gtags", function(args)
    run_global(args.args, "")
  end, { nargs = "*", complete = "file" })

  vim.api.nvim_create_user_command("Gtagsa", function(args)
    run_global(args.args, "a")
  end, { nargs = "*", complete = "file" })

  vim.api.nvim_create_user_command("GtagsCursor", function()
    gtags_cursor()
  end, { nargs = 0 })

  vim.api.nvim_create_user_command("Gozilla", function()
    gozilla()
  end, { nargs = 0 })

  vim.api.nvim_create_user_command("GtagsUpdate", function()
    gtags_auto_update()
  end, { nargs = 0 })

  -- Auto update on write
  if config.auto_update == 1 then
    vim.api.nvim_create_autocmd("BufWritePost", {
      pattern = "*",
      callback = gtags_auto_update,
    })
  end

  -- Auto mappings
  if config.auto_map == 1 then
    vim.keymap.set("n", "<F2>", "<cmd>copen<CR>")
    vim.keymap.set("n", "<F4>", "<cmd>cclose<CR>")
    -- F5-F8 reserved for DAP debugging
    -- vim.keymap.set("n", "<F5>", "<cmd>Gtags ")
    -- vim.keymap.set("n", "<F6>", "<cmd>Gtags -f %<CR>")
    -- vim.keymap.set("n", "<F7>", "<cmd>GtagsCursor<CR>")
    -- vim.keymap.set("n", "<F8>", "<cmd>Gozilla<CR>")
    vim.keymap.set("n", "<C-n>", "<cmd>cn<CR>")
    vim.keymap.set("n", "<C-p>", "<cmd>cp<CR>")
    vim.keymap.set("n", "<C-\\><C-]>", "<cmd>GtagsCursor<CR>")
  end
end

return M

