local M = {}
local map = vim.keymap.set

M.setup_keymaps = function(bufnr)
  local function opts(desc)
    return { buffer = bufnr, desc = "LSP " .. desc }
  end
  map("n", "gD", vim.lsp.buf.declaration, opts("Go to declaration"))
  map("n", "gd", vim.lsp.buf.definition, opts("Go to definition"))
  map("n", "K", vim.lsp.buf.hover, opts("Hover"))
  map("n", "gI", vim.lsp.buf.implementation, opts("Go to implementation"))
  map("n", "<leader>h", vim.lsp.buf.signature_help, opts("Show signature help"))
  map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts("Add workspace folder"))
  map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts("Remove workspace folder"))
  map("n", "<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, opts("List workspace folders"))
  map({ "n" }, "<leader>ce", function()
    require("scripts.diagnostics").hover()
  end, { desc = "Floating diagnostic" })
  map("n", "<leader>D", vim.lsp.buf.type_definition, opts("Go to type definition"))
  map("n", "<leader>ra", vim.lsp.buf.rename, opts("Rename"))
  map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts("Code action"))
  map("n", "gr", vim.lsp.buf.references, opts("Show references"))
end

M.setup_diagnostics = function()
  local icons = { Error = " ", Warn = " ", Info = " ", Hint = " " }

  local signs = {
    { name = "DiagnosticSignError", text = icons.Error },
    { name = "DiagnosticSignWarn",  text = icons.Warn },
    { name = "DiagnosticSignInfo",  text = icons.Info },
    { name = "DiagnosticSignHint",  text = icons.Hint },
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
    virtual_text = false,
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

local has_cmp_nvim_lsp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if has_cmp_nvim_lsp then
  M.capabilities = cmp_nvim_lsp.default_capabilities(M.capabilities)
end

M.on_attach = function(client, bufnr)
  M.setup_keymaps(bufnr)
  if client.supports_method("textDocument/semanticTokens") then
    client.server_capabilities.semanticTokensProvider = nil
  end
  if client.supports_method("textDocument/inlayHint") then
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
  end
end

-- Setup diagnostics globally
M.setup_diagnostics()

-- Setup fancy diagnostics
require("scripts.diagnostics").setup()

-- Global LspAttach autocmd
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local bufnr = args.buf
    M.on_attach(client, bufnr)
  end,
})

return M
