local git = require("utils.git")
git.setup()
local map = vim.keymap.set

-- vim.g.mapleader = ";"

-- still cursor on J
map("n", "J", "mzJ`z")

-- diagnostics
map("n", "<leader>cl", vim.diagnostic.setloclist, { desc = "Loclist: Errors" })
map("n", "<leader>cL", vim.diagnostic.setqflist, { desc = "Qflist: Errors" })

-- path file
map("n", "<leader>pt", function()
  vim.cmd([[echo expand('%:p')]])
end, { desc = "Show File Path" })

--format
map({ "n", "v" }, "<leader>fm", function()
  vim.lsp.buf.format({
    async = false,
    timeout_ms = 1000,
  })
end)

-- Alias for quit commands
map("c", "Qa", "qa", { noremap = true, silent = true })
map("c", "QA", "qa", { noremap = true, silent = true })
map("c", "qA", "qa", { noremap = true, silent = true })
map("c", "Q", "q", { noremap = true, silent = true })

-- exit insert mode with jk
map("i", "jk", "<ESC>", { noremap = true, silent = true })
map("i", "kj", "<ESC>", { noremap = true, silent = true })

-- Duplicate a line and comment out the first line
map("n", "yc", "yy:normal gcc<CR>p", { desc = "Duplicate line and comment original" })

-- Insert mode mappings
map("i", "<C-b>", "<ESC>^i", { desc = "move to beginning of line" })
map("i", "<C-e>", "<End>", { desc = "move to end of line" })
map("i", "<C-h>", "<Left>", { desc = "move left" })
map("i", "<C-l>", "<Right>", { desc = "move right" })
map("i", "<C-j>", "<Down>", { desc = "move down" })
map("i", "<C-k>", "<Up>", { desc = "move up" })

-- move lines
map("i", "<A-j>", "<Esc>:m .+1<CR>==gi", { desc = "Move line down" })
map("i", "<A-k>", "<Esc>:m .-2<CR>==gi", { desc = "Move line up" })

map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move line up" })

-- General mappings
map("n", "<C-d>", "<c-d>zz", { desc = "Scroll down and center" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })
-- lines moving normal mode
map("n", "j", "v:count || mode(1)[0:1] == 'no' ? 'j' : 'gj'", { expr = true, noremap = true, silent = true })
map("n", "k", "v:count || mode(1)[0:1] == 'no' ? 'k' : 'gk'", { expr = true, noremap = true, silent = true })
map("n", "<Up>", "v:count || mode(1)[0:1] == 'no' ? 'k' : 'gk'", { expr = true, noremap = true, silent = true })
map("n", "<Down>", "v:count || mode(1)[0:1] == 'no' ? 'j' : 'gj'", { expr = true, noremap = true, silent = true })

-- lines moving visual mode
map("v", "<Up>", "v:count || mode(1)[0:1] == 'no' ? 'k' : 'gk'", { expr = true, noremap = true, silent = true })
map("v", "<Down>", "v:count || mode(1)[0:1] == 'no' ? 'j' : 'gj'", { expr = true, noremap = true, silent = true })
map("v", "<", "<gv", { desc = "Indent line" })
map("v", ">", ">gv", { desc = "Indent line" })

-- tmux navigation
if vim.fn.exists("$TMUX") == 1 then
  map("n", "<C-h>", "<cmd> TmuxNavigateLeft<CR>")
  map("n", "<C-l>", "<cmd> TmuxNavigateRight<CR>")
  map("n", "<C-j>", "<cmd> TmuxNavigateDown<CR>")
  map("n", "<C-k>", "<cmd> TmuxNavigateUp<CR>")
else
  -- window navigation
  map("n", "<C-h>", "<C-w>h", { desc = "switch to left window" })
  map("n", "<C-l>", "<C-w>l", { desc = "switch to right window" })
  map("n", "<C-j>", "<C-w>j", { desc = "switch to bottom window" })
  map("n", "<C-k>", "<C-w>k", { desc = "switch to top window" })
end

map("n", "<CR>", "<cmd>w<CR>", { desc = "save file" })
map("n", "<C-c>", "<cmd>%y+<CR>", { desc = "general copy whole file" })
map("n", "n", "nzzzv", { desc = "Next search result centered" })
map("n", "N", "Nzzzv", { desc = "Previous search result centered" })
map("n", "*", "*zzzv", { desc = "Search word under cursor centered" })
map("n", "#", "#zzzv", { desc = "Search word under cursor backwards centered" })

map("n", "<leader>n", "<cmd>set nu!<CR>", { desc = "toggle line numbers" })
map("n", "<leader>rn", "<cmd>set rnu!<CR>", { desc = "toggle relative numbers" })

-- nvim-tree
map("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "toggle file explorer" })

map("n", "<leader>wK", "<cmd>WhichKey <CR>", { desc = "whichkey all keymaps" })
map("n", "<leader>wk", function()
  vim.cmd("WhichKey " .. vim.fn.input("WhichKey: "))
end, { desc = "whichkey query lookup" })

-- DAP mappings
local dap_map = vim.keymap.set

dap_map("n", "<F10>", "<cmd>lua require('dap').toggle_breakpoint()<CR>", { desc = "Toggle breakpoint" })
dap_map("n", "<F5>", "<cmd>lua require('dap').continue()<CR>", { desc = "Continue" })
dap_map("n", "<F9>", "<cmd>lua require('dap').restart()<CR>", { desc = "Restart" })
dap_map("n", "<F7>", "<cmd>lua require('dap').step_out()<CR>", { desc = "Step out" })
dap_map("n", "<F6>", "<cmd>lua require('dap').step_into()<CR>", { desc = "Step into" })
dap_map("n", "<F8>", "<cmd>lua require('dap').step_over()<CR>", { desc = "Step over" })
dap_map("n", "<leader>dpr", function()
  local args = vim.fn.input("Arguments: ")
  vim.cmd("RustLsp debuggables " .. args)
end, { desc = "Select and run Rust debuggable" })

-- bufferline, cycle buffers
map("n", "<Tab>", "<cmd>bnext<CR>")
map("n", "<S-Tab>", "<cmd>bprev<CR>")
map("n", "<leader>b", "<cmd> enew <CR>")
map("n", "<leader>x", function()
  if vim.bo.modified then
    local choice = vim.fn.confirm("Buffer não salvo. Deseja salvar?", "&Sim\n&Não\n&Cancelar", 3)
    if choice == 1 then
      vim.cmd("write")
    elseif choice == 3 then
      return
    end
  end

  local current = vim.api.nvim_get_current_buf()
  vim.cmd("bnext")
  vim.cmd("bdelete " .. current)
end, { noremap = true, silent = true })

-- Plugin keymaps
map("n", "<leader>fw", "<cmd>FzfLua live_grep --fixed-strings<CR>", { desc = "search live with fzf-lua" })
map("n", "<leader>fb", "<cmd>FzfLua buffers<CR>", { desc = "find buffers with fzf-lua" })
map("n", "<leader>fh", "<cmd>FzfLua help_tags<CR>", { desc = "search help tags with fzf-lua" })
map("n", "<leader>ma", "<cmd>FzfLua marks<CR>", { desc = "find marks with fzf-lua" })
map("n", "<leader>fo", "<cmd>FzfLua oldfiles<CR>", { desc = "find old files with fzf-lua" })
map("n", "<leader>fz", "<cmd>FzfLua blines --fixed-strings<CR>", { desc = "find in current buffer with fzf-lua" })
map("n", "<leader>cm", "<cmd>FzfLua git_commits<CR>", { desc = "browse git commits with fzf-lua" })
map("n", "<leader>gt", "<cmd>FzfLua git_status<CR>", { desc = "git status with fzf-lua" })
map("n", "<leader>ff", "<cmd>FzfLua files<CR>", { desc = "find files with fzf-lua" })
map("n", "<leader>fc", "<cmd>FzfLua command_history<CR>", { desc = "find in current buffer with fzf-lua" })
map("n", "<leader>fds", "<cmd>FzfLua lsp_document_symbols<CR>", { desc = "Document symbols with fzf-lua" })
map("n", "<leader>th", "<cmd>FzfLua colorschemes<CR>", { desc = "change colorscheme with fzf-lua" })

-- Gitsigns
map("n", "<leader>]c", function()
  require("gitsigns").next_hunk()
end, { desc = "Next git hunk" })
map("n", "<leader>[c", function()
  require("gitsigns").prev_hunk()
end, { desc = "Prev git hunk" })
map("n", "<leader>rh", function()
  require("gitsigns").reset_hunk()
end, { desc = "Reset hunk" })
map("n", "<leader>ph", function()
  require("gitsigns").preview_hunk()
end, { desc = "Preview hunk" })
map("n", "<leader>gb", function()
  require("gitsigns").blame_line()
end, { desc = "Git blame line" })
map("n", "<leader>td", function()
  require("gitsigns").toggle_deleted()
end, { desc = "Toggle deleted" })
