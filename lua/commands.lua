vim.api.nvim_create_user_command("MasonInstallAll", function()
  vim.cmd(
    " MasonInstall debugpy js-debug-adapter netcoredbg "
  )
end, {})
