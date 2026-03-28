local M = {}
local buffer_formatters = {}
local group = vim.api.nvim_create_augroup("BufferFormatters", { clear = true })

local function notify_error(message)
  vim.notify(message, vim.log.levels.ERROR)
end

function M.run_file_commands(commands)
  local file = vim.fn.expand("%:p")
  if file == "" then
    notify_error("No file to format")
    return
  end

  local cursor = vim.api.nvim_win_get_cursor(0)
  vim.cmd("write")

  for _, command in ipairs(commands) do
    local result = vim.system(vim.list_extend(command, { file }), { text = true }):wait()
    if result.code ~= 0 then
      notify_error((result.stderr and result.stderr ~= "") and result.stderr or ("Command failed: " .. table.concat(command, " ")))
      vim.api.nvim_win_set_cursor(0, cursor)
      return
    end
  end

  vim.cmd("checktime")
  vim.api.nvim_win_set_cursor(0, cursor)
end

function M.set_buffer_formatter(bufnr, formatter)
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
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  local formatter = buffer_formatters[bufnr]
  if formatter then
    formatter()
    return
  end

  vim.lsp.buf.format({
    async = false,
    timeout_ms = 1000,
  })
end

return M
