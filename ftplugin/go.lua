local format = require("format.helpers")
local bufnr = vim.api.nvim_get_current_buf()

local function organize_imports(buf)
  buf = buf or vim.api.nvim_get_current_buf()

  local clients = vim.lsp.get_clients({
    bufnr = buf,
    name = "gopls",
    method = "textDocument/codeAction",
  })
  if #clients == 0 then
    return
  end

  local params = {
    textDocument = vim.lsp.util.make_text_document_params(buf),
    range = {
      start = { line = 0, character = 0 },
      ["end"] = { line = vim.api.nvim_buf_line_count(buf), character = 0 },
    },
  }
  params.context = {
    only = { "source.organizeImports" },
    diagnostics = {},
  }

  for _, client in ipairs(clients) do
    local result = client:request_sync("textDocument/codeAction", params, 1000, buf)

    for _, action in ipairs((result and result.result) or {}) do
      if action.edit then
        vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding or "utf-16")
      end

      local command = action.command
      if command then
        client:exec_cmd(type(command) == "table" and command or action, { bufnr = buf })
      end
    end
  end
end

local function format_go(buf)
  buf = buf or vim.api.nvim_get_current_buf()

  organize_imports(buf)
  vim.lsp.buf.format({
    async = false,
    bufnr = buf,
    name = "gopls",
    timeout_ms = 1000,
  })
end

vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("GoFormat", { clear = false }),
  buffer = bufnr,
  callback = function(event)
    format_go(event.buf)
  end,
})

format.set_buffer_formatter(bufnr, function()
  format_go(bufnr)
end)
