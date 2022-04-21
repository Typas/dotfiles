-- some vim settings
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.encoding = "utf-8"
vim.opt.showcmd = true
vim.opt.number = true
vim.opt.syntax = "enable"
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.autoindent = true
vim.opt.filetype = "plugin"
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.background = "light"
vim.opt_local.formatoptions = vim.opt_local.formatoptions - {"c", "r", "o"}
