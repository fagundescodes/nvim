local cmp = require("cmp")

local cmp_kinds = {
  Namespace = "󰌗",
  Text = "",
  Method = "",
  Function = "󰊕",
  Constructor = "",
  Field = "󰜢",
  Variable = "󰀫",
  Class = "󰠱",
  Interface = "",
  Module = "",
  Property = "",
  Unit = "󰑭",
  Value = "󰎠",
  Enum = "",
  Keyword = "󰌋",
  Snippet = "",
  -- Snippet = "󰘍",
  Color = "󰏘",
  File = "󰈚",
  Reference = "󰌹",
  Folder = "󰉋",
  EnumMember = "",
  Constant = "󰏿",
  Struct = "󰙅",
  Event = "",
  Operator = "󰆕",
  TypeParameter = "󰊄",
}

local function border(hl_name)
  return {
    { "╭", hl_name },
    { "─", hl_name },
    { "╮", hl_name },
    { "│", hl_name },
    { "╯", hl_name },
    { "─", hl_name },
    { "╰", hl_name },
    { "│", hl_name },
  }
end

local formatting_style = {
  fields = { "kind", "abbr", "menu" },
  format = function(entry, item)
    local icon = cmp_kinds[item.kind] or ""
    icon = " " .. icon .. " "
    item.menu = "   (" .. item.kind .. ")"
    item.kind = icon
    return item
  end,
}

cmp.setup({
  completion = {
    completeopt = "menu,menuone,noinsert",
    autocomplete = false,
  },

  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },

  mapping = {
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.close(),
    ["<CR>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif require("luasnip").expand_or_jumpable() then
        require("luasnip").expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif require("luasnip").jumpable(-1) then
        require("luasnip").jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  },

  sources = {
    { name = "nvim_lsp", priority = 1000 },
    { name = "luasnip", priority = 750 },
    { name = "buffer", priority = 500 },
    { name = "nvim_lua", priority = 400 },
    { name = "path", priority = 250 },
    { name = "spell", priority = 100 },
  },

  formatting = formatting_style,

  window = {
    completion = {
      side_padding = 0,
      winhighlight = "Normal:CmpPmenu,CursorLine:CmpSel,Search:None",
      scrollbar = false,
      border = border("CmpBorder"),
    },
    documentation = {
      border = border("CmpDocBorder"),
      winhighlight = "Normal:CmpDoc",
    },
  },

  experimental = {
    ghost_text = true,
  },
})

cmp.event:on("menu_opened", function()
  vim.schedule(function()
    if cmp.visible() then
      cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
    end
  end)
end)

vim.cmd([[
  highlight! default link CmpSel PmenuSel
  highlight! default link CmpPmenu Pmenu
  highlight! default link CmpPmenuSel PmenuSel
  highlight! default link CmpBorder Pmenu
  highlight! default link CmpDoc Pmenu
  highlight! default link CmpDocBorder Pmenu
]])

vim.o.pumheight = 10

vim.api.nvim_create_autocmd("LspAttach", {
  desc = "Habilitar inlay hints",
  callback = function(event)
    local id = vim.tbl_get(event, "data", "client_id")
    local client = id and vim.lsp.get_client_by_id(id)
    if client == nil or not client.supports_method("textDocument/inlayHint") then
      return
    end
    vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
  end,
})

return cmp

