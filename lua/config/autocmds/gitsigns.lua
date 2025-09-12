---Git chunks gutter signs
local M = {}
local git = require("utils.git")

-- OPTIONS =====================================================================

M.opts = {}
M.opts.namespace = vim.api.nvim_create_namespace(_G.ConfigPrefix .. "GitSigns")
M.opts.group = vim.api.nvim_create_augroup(_G.ConfigPrefix .. "GitSigns", { clear = true })

M.opts.highlights = {
  [git.chunk_types.ADDED] = "Added",
  [git.chunk_types.REMOVED] = "Removed",
  [git.chunk_types.CHANGED] = "Changed",
}

M.opts.signs = {
  [git.chunk_types.ADDED] = "+",
  [git.chunk_types.REMOVED] = "-",
  [git.chunk_types.CHANGED] = "|",
}

-- PRIVATE FIELDS / METHODS ====================================================

local guard = false

local function set_extmarks(buf)
  vim.api.nvim_buf_clear_namespace(buf, M.opts.namespace, 0, -1)
  local chunks = git.buf_diff.get(buf)
  local buf_line_count = vim.api.nvim_buf_line_count(buf)

  for _, chunk in ipairs(chunks) do
    -- quirks around zero-based indexing
    -- added and changed chunks are 1 ahead of the actual position
    -- removed chunks need no offset
    local offset = chunk.type == git.chunk_types.REMOVED and 0 or 1
    local start_row = math.max(0, chunk.line - offset)
    local end_row = math.min(buf_line_count - 1, chunk.line + chunk.count - (offset + 1))

    -- Only set extmark if the range is valid
    if start_row <= end_row and start_row < buf_line_count then
      vim.api.nvim_buf_set_extmark(buf, M.opts.namespace, start_row, 0, {
        end_row = end_row, -- extra offset for end-inclusive indexing
        sign_text = M.opts.signs[chunk.type],
        sign_hl_group = M.opts.highlights[chunk.type],
        priority = 9, -- diagnostics (10) should have prio over this
      })
    end
  end
end

-- PUBLIC METHODS ==============================================================

function M.setup()
  if guard then
    return
  end
  guard = true

  vim.api.nvim_create_autocmd("User", {
    pattern = git.events.BUF_DIFF,
    group = M.opts.group,
    callback = function(args)
      set_extmarks(args.data.buf)
    end,
  })
end

M.setup()

return M
