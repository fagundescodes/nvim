local utils = require("lsp.utils")
local lsp = require("lsp.helpers")
local format = require("format.helpers")

local function organize_imports()
  local params = vim.lsp.util.make_range_params(0, "utf-8")
  params.context = {
    only = { "source.organizeImports" },
    diagnostics = {},
  }

  local results = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 1000)
  if not results then
    return
  end

  for client_id, result in pairs(results) do
    for _, action in ipairs(result.result or {}) do
      if action.edit then
        local client = vim.lsp.get_client_by_id(client_id)
        vim.lsp.util.apply_workspace_edit(action.edit, client and client.offset_encoding or "utf-16")
      end
      if action.command then
        vim.lsp.buf.execute_command(action.command)
      end
    end
  end
end

vim.lsp.start({
  name = "gopls",
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_dir = lsp.find_root({ "go.work", "go.mod", ".git" }),
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
      gofumpt = true,
      completeUnimported = true,
      usePlaceholders = true,
      hints = {
        parameterNames = true,
        rangeVariableTypes = true,
      },
    },
  },
  capabilities = utils.capabilities,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("GoFormat", { clear = false }),
  buffer = 0,
  callback = function()
    organize_imports()
    vim.lsp.buf.format({ async = false })
  end,
})

format.set_buffer_formatter(0, function()
  organize_imports()
  vim.lsp.buf.format({ async = false })
end)
