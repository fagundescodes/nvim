local M = {}
local map = vim.keymap.set

M.setup_keymaps = function(bufnr)
  local function opts(desc)
    return { buffer = bufnr, desc = "LSP " .. desc }
  end
  map("n", "gD", vim.lsp.buf.declaration, opts("Go to declaration"))
  map("n", "gd", vim.lsp.buf.definition, opts("Go to definition"))
  map("n", "K", vim.lsp.buf.hover, opts("Hover"))
  map("n", "gi", vim.lsp.buf.implementation, opts("Go to implementation"))
  map("n", "<leader>h", vim.lsp.buf.signature_help, opts("Show signature help"))
  map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts("Add workspace folder"))
  map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts("Remove workspace folder"))
  map("n", "<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, opts("List workspace folders"))
  map(
    { "n" },
    "<leader>ce",
    "<cmd>lua vim.diagnostic.open_float { border = 'rounded' }<CR>",
    { desc = "Floating diagnostic" }
  )
  map("n", "<leader>D", vim.lsp.buf.type_definition, opts("Go to type definition"))
  map("n", "<leader>ra", vim.lsp.buf.rename, opts("Rename"))
  map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts("Code action"))
  map("n", "gr", vim.lsp.buf.references, opts("Show references"))
end

M.setup_diagnostics = function()
  local icons = { Error = " ", Warn = " ", Info = " ", Hint = " " }

  local signs = {
    { name = "DiagnosticSignError", text = icons.Error },
    { name = "DiagnosticSignWarn", text = icons.Warn },
    { name = "DiagnosticSignInfo", text = icons.Info },
    { name = "DiagnosticSignHint", text = icons.Hint },
  }

  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, {
      texthl = sign.name,
      text = sign.text,
      numhl = sign.name,
    })
  end

  vim.diagnostic.config({
    severity_sort = true,
    virtual_text = {
      severity = {
        min = vim.diagnostic.severity.WARN,
      },
      prefix = "●",
    },
    virtual_lines = { current_line = true },
    underline = true,
    signs = {
      active = signs,
      text = {
        [vim.diagnostic.severity.ERROR] = icons.Error,
        [vim.diagnostic.severity.WARN] = icons.Warn,
        [vim.diagnostic.severity.INFO] = icons.Info,
        [vim.diagnostic.severity.HINT] = icons.Hint,
      },
    },
    float = {
      border = "rounded",
      focusable = true,
      source = "if_many",
      header = "",
      prefix = "",
    },
  })

  -- Uncomment below to enable diagnostic float in top-right corner on cursor move
  --[[
  local timer = vim.loop and vim.loop.new_timer() or vim.uv.new_timer()
  local delay = 50
  vim.api.nvim_create_autocmd({ "CursorMoved", "DiagnosticChanged" }, {
    callback = function()
      timer:start(delay, 0, function()
        timer:stop()
        vim.schedule(function()
          local _, win = vim.diagnostic.open_float(nil, { focusable = false, source = "if_many" })
          if not win then
            return
          end

          local cfg = vim.api.nvim_win_get_config(win)
          cfg.anchor = "NE"
          cfg.row = 0
          cfg.col = vim.o.columns - 1
          cfg.width = math.min(cfg.width or 999, math.floor(vim.o.columns * 0.6))
          cfg.height = math.min(cfg.height or 999, math.floor(vim.o.lines * 0.4))

          vim.api.nvim_win_set_config(win, cfg)
        end)
      end)
    end,
  })
  --]]
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities.textDocument.completion.completionItem = {
  documentationFormat = { "markdown", "plaintext" },
  snippetSupport = true,
  preselectSupport = true,
  insertReplaceSupport = true,
  labelDetailsSupport = true,
  deprecatedSupport = true,
  commitCharactersSupport = true,
  tagSupport = { valueSet = { 1 } },
  resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  },
}

M.on_attach = function(client, bufnr)
  M.setup_keymaps(bufnr)
  if client.supports_method("textDocument/semanticTokens") then
    client.server_capabilities.semanticTokensProvider = nil
  end
  if client.supports_method("textDocument/inlayHint") then
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
  end
end

return M
