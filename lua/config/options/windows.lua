local is_unix = vim.fn.has("unix") == 1
local is_wsl = false

-- Check if we're in WSL
if is_unix then
  if vim.fn.filereadable("/proc/sys/fs/binfmt_misc/WSLInterop") == 1 then
    is_wsl = true
  elseif vim.fn.filereadable("/proc/version") == 1 then
    local version_content = vim.fn.readfile("/proc/version")
    if version_content[1] and version_content[1]:match("Microsoft") then
      is_wsl = true
    end
  end
end

if is_wsl then
  vim.g.clipboard = {
    name = "WslClipboard",
    copy = {
      ["+"] = "clip.exe",
      ["*"] = "clip.exe",
    },
    paste = {
      ["+"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
      ["*"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    },
    cache_enabled = 0,
  }
-- For native Linux, let Neovim handle clipboard automatically
elseif not is_unix then
  local powershell_options = {
    shell = vim.fn.executable("pwsh") == 1 and "pwsh" or "powershell",
    shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;",
    -- shellredir = '-RedirectStandardOutput %s -NoNewWindow -Wait',
    shellredir = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode",
    shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode",
    shellquote = "",
    shellxquote = "",
  }

  for option, value in pairs(powershell_options) do
    vim.opt[option] = value
  end
end
