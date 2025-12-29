local ts = require("nvim-treesitter")

local waiting_buffers = {}
local installing_langs = {}

local group = vim.api.nvim_create_augroup("TreesitterSetup", { clear = true })

local function enable_treesitter(buf, lang)
  if not vim.api.nvim_buf_is_valid(buf) then
    return false
  end

  local ok = pcall(vim.treesitter.start, buf, lang)
  if ok then
    vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end
  return ok
end

vim.api.nvim_create_autocmd("User", {
  group = group,
  pattern = "LazyDone",
  once = true,
  desc = "Install core treesitter parsers",
  callback = function()
    ts.install({
      "vim",
      "lua",
      "vimdoc",
      "luadoc",
      "html",
      "css",
      "javascript",
      "typescript",
      "tsx",
      "vue",
      "c",
      "zig",
      "rust",
      "cpp",
      "python",
      "json",
      "yaml",
      "toml",
      "bash",
      "go",
      "java",
      "regex",
      "c_sharp",
      "sql",
      "markdown",
      "markdown_inline",
    }, {
      max_jobs = 8,
    })
  end,
})

local ignore_filetypes = {
  checkhealth = true,
  lazy = true,
  mason = true,
  help = true,
  qf = true,
}

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  desc = "Enable treesitter highlighting and indentation",
  callback = function(event)
    if ignore_filetypes[event.match] then
      return
    end

    local lang = vim.treesitter.language.get_lang(event.match) or event.match
    local buf = event.buf

    if not enable_treesitter(buf, lang) then
      waiting_buffers[lang] = waiting_buffers[lang] or {}
      waiting_buffers[lang][buf] = true

      if not installing_langs[lang] then
        installing_langs[lang] = true
        local task = ts.install({ lang })

        if task and task.await then
          task:await(function()
            vim.schedule(function()
              installing_langs[lang] = nil

              local buffers = waiting_buffers[lang]
              if buffers then
                for b in pairs(buffers) do
                  enable_treesitter(b, lang)
                end
                waiting_buffers[lang] = nil
              end
            end)
          end)
        else
          installing_langs[lang] = nil
          waiting_buffers[lang] = nil
        end
      end
    end
  end,
})

vim.api.nvim_create_autocmd("BufDelete", {
  group = group,
  desc = "Clean up treesitter waiting buffers",
  callback = function(event)
    for lang, buffers in pairs(waiting_buffers) do
      buffers[event.buf] = nil
      if next(buffers) == nil then
        waiting_buffers[lang] = nil
      end
    end
  end,
})
