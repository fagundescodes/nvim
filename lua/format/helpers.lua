local M = {}
local buffer_formatters = {}
local group = vim.api.nvim_create_augroup("BufferFormatters", { clear = true })

local function notify_error(message)
  vim.notify(message, vim.log.levels.ERROR)
end

local function resolve_bufnr(bufnr)
  if bufnr == nil or bufnr == 0 then
    return vim.api.nvim_get_current_buf()
  end

  return bufnr
end

function M.run_file_commands(commands, bufnr)
  bufnr = resolve_bufnr(bufnr)

  local file = vim.api.nvim_buf_get_name(bufnr)
  if file == "" then
    notify_error("No file to format")
    return
  end

  local win = vim.fn.bufwinid(bufnr)
  local cursor = win ~= -1 and vim.api.nvim_win_get_cursor(win) or nil
  local function restore_cursor()
    if cursor and win ~= -1 and vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_set_cursor(win, cursor)
    end
  end

  vim.api.nvim_buf_call(bufnr, function()
    vim.cmd("write")
  end)

  for _, command in ipairs(commands) do
    local argv = vim.list_extend(vim.deepcopy(command), { file })
    local result = vim.system(argv, { text = true }):wait()
    if result.code ~= 0 then
      notify_error((result.stderr and result.stderr ~= "") and result.stderr or ("Command failed: " .. table.concat(command, " ")))
      restore_cursor()
      return
    end
  end

  vim.api.nvim_buf_call(bufnr, function()
    vim.cmd("checktime")
  end)

  restore_cursor()
end

function M.set_buffer_formatter(bufnr, formatter)
  bufnr = resolve_bufnr(bufnr)
  buffer_formatters[bufnr] = formatter

  vim.api.nvim_create_autocmd("BufWipeout", {
    group = group,
    buffer = bufnr,
    once = true,
    callback = function(event)
      buffer_formatters[event.buf] = nil
    end,
  })
end

function M.format(bufnr)
  bufnr = resolve_bufnr(bufnr)

  local formatter = buffer_formatters[bufnr]
  if formatter then
    formatter()
    return
  end

  vim.lsp.buf.format({
    async = false,
    bufnr = bufnr,
    timeout_ms = 5000,
  })
end

return M
