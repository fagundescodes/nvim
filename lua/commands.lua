vim.api.nvim_create_user_command("LazyGit", function()
  if vim.fn.executable("lazygit") == 0 then
    vim.notify("lazygit not found", vim.log.levels.ERROR)
    return
  end

  require("term").run({ "lazygit" })
end, {})
