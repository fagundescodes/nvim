local M = {}
local map = vim.keymap.set

local function semantic_tokens_disabled_for(client, bufnr)
  local disabled_servers = vim.g.lsp_semantic_tokens_disabled_servers or {
    jdtls = true,
  }

  if disabled_servers[client.name] then
    return true
  end

  local disabled_filetypes = vim.g.lsp_semantic_tokens_disabled_filetypes or {}
  local filetype = vim.bo[bufnr].filetype

  return disabled_filetypes[filetype] == true
end

M.setup_keymaps = function(bufnr)
  local function opts(desc)
    return { buf = bufnr, desc = "LSP " .. desc }
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
end

M.setup_diagnostics = function()
  local icons = { Error = " ", Warn = " ", Info = " ", Hint = " " }

  vim.diagnostic.config({
    severity_sort = true,
    virtual_text = false,
    virtual_lines = { current_line = true },
    underline = true,
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = icons.Error,
        [vim.diagnostic.severity.WARN] = icons.Warn,
        [vim.diagnostic.severity.INFO] = icons.Info,
        [vim.diagnostic.severity.HINT] = icons.Hint,
      },
      numhl = {
        [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
        [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
        [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
        [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
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

M.setup_default_config = function()
  vim.lsp.config("*", {
    capabilities = M.capabilities,
  })
end

M.enable_configs = function()
  vim.lsp.enable({
    "basedpyright",
    "clangd",
    "gopls",
    "lua_ls",
    "rust_analyzer",
    "ts_ls",
    "zls",
  })
end

M.on_attach = function(client, bufnr)
  M.setup_keymaps(bufnr)
  if client:supports_method("textDocument/semanticTokens") and semantic_tokens_disabled_for(client, bufnr) then
    client.server_capabilities.semanticTokensProvider = nil
  end
  if client:supports_method("textDocument/inlayHint") then
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
  end
end

M.setup_diagnostics()

M.setup_default_config()

M.enable_configs()

require("scripts.diagnostics").setup()

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local bufnr = args.buf
    M.on_attach(client, bufnr)
  end,
})

return M
