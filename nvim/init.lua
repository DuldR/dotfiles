local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim" if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "

Config = {
	theme = "gruvbox"
	-- theme = "tokyonight"
}

require("config.lazy")

vim.wo.number = true
vim.wo.relativenumber = true
vim.o.tgc = true
vim.o.textwidth = 80
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.cursorline = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.opt.swapfile = false

vim.keymap.set("n", "<Space>", "<Nop>", { silent = true, remap = false })
vim.keymap.set("n", "<leader>T", "<cmd>TestFile<CR> <bar> <cmd>windcmd =<CR>")
vim.keymap.set("n", "<leader>N", "<cmd>TestNearest<CR>")
vim.keymap.set("n", "<leader>q", "<cmd>VimuxCloseRunner<CR>")
vim.keymap.set("n", "<leader>E", ":e#<CR>")
vim.keymap.set("n", "<leader>src", ":%s///gc<Left><Left><Left><Left>")
vim.keymap.set("v", "<leader>srv", ":s///gc<Left><Left><Left><Left>")
vim.keymap.set("n", "<C-a>", ":set relativenumber!<CR>")
vim.keymap.set("n", "q", "<Nop>")
vim.keymap.set("n", "Q", "<Nop>")
vim.g['test#strategy'] = 'vimux'
vim.g.VimuxOrientation = 'h'
vim.g.VimuxCloseOnExit = 1
vim.g.VimuxHeight = 30 

-- vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format()]]
vim.cmd [[autocmd VimResized * wincmd =]]

