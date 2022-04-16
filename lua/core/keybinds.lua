
-- leader key set to space
vim.g.mapleader = " "

vim.keybinds = {
  gmap = vim.api.nvim_set_keymap,
  bmap = vim.api.nvim_buf_set_keymap,
  dgmap = vim.api.nvim_del_keymap,
  dbmap = vim.api.nvim_buf_del_keymap,
  opts = {noremap = true},
}

vim.keybinds.gmap("n", "<ESC>", ":nohlsearch<CR>", vim.keybinds.opts)

-- map keybinds to fit doom emacs
vim.keybinds.gmap("n", "<leader>wv", ":vsp<CR>", vim.keybinds.opts)
vim.keybinds.gmap("n", "<leader>ws", ":sp<CR>", vim.keybinds.opts)
vim.keybinds.gmap("n", "<leader>w", "<C-w>", vim.keybinds.opts)

-- packer commands
vim.keybinds.gmap("n", "<leader>pc", ":PackerCompile<CR>", vim.keybinds.opts)
vim.keybinds.gmap("n", "<leader>pu", ":PackerUpdate<CR>", vim.keybinds.opts)
vim.keybinds.gmap("n", "<leader>ps", ":PackerSync<CR>", vim.keybinds.opts)

-- telescope commands
vim.keybinds.gmap("n", "<leader>ff", ":Telescope find_files<CR>", vim.keybinds.opts)
vim.keybinds.gmap("n", "<leader>fg", ":Telescope live_grep<CR>", vim.keybinds.opts)
vim.keybinds.gmap("n", "<leader>fb", ":Telescope buffers<CR>", vim.keybinds.opts)
vim.keybinds.gmap("n", "<leader>fh", ":Telescope help_tags<CR>", vim.keybinds.opts)
