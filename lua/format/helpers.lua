local M = {}

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

function M.format_current_buffer_with(command)
  local bufnr = vim.api.nvim_get_current_buf()
  local file = vim.fn.expand("%:p")
  if file == "" then
    notify_error("No file to format")
    return
  end

  local result = vim.system(command(file), {
    stdin = table.concat(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false), "\n"),
    text = true,
  }):wait()

  if result.code ~= 0 then
    notify_error((result.stderr and result.stderr ~= "") and result.stderr or "Formatter failed")
    return
  end

  local output = vim.split(result.stdout, "\n", { plain = true })
  if output[#output] == "" then
    table.remove(output, #output)
  end
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, output)
end

return M
