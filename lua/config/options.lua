local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.breakindent = true
opt.undofile = true
opt.ignorecase = true
opt.smartcase = true
opt.signcolumn = "yes"
opt.updatetime = 250
opt.timeoutlen = 300
opt.splitright = true
opt.splitbelow = true
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
opt.inccommand = "split"
opt.cursorline = true
opt.scrolloff = 8
opt.confirm = true
opt.termguicolors = true
opt.completeopt = { "menu", "menuone", "noselect" }

if vim.fn.has("win32") == 1 then
  opt.shell = vim.fn.executable("pwsh") == 1 and "pwsh" or "powershell.exe"
  opt.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command"
  opt.shellredir = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
  opt.shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
  opt.shellquote = ""
  opt.shellxquote = ""
end

if vim.g.neovide then
  vim.o.guifont = "Maple Mono NF CN,Source Code Pro,Fira Code,monospace"
end

opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.smartindent = true
