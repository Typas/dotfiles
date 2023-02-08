local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable",
      lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)


require("core.settings")
require("core.keybinds")
require("core.config")
require("core.plugins")

require("lazy").setup("core.plugins")
