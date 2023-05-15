local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
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
require("lazy").setup(
	{
		{
			'nvim-telescope/telescope.nvim',
			tag = '0.1.1',
			-- or                              , branch = '0.1.1',
			dependencies = { 'nvim-lua/plenary.nvim' }
		},
		{
			"williamboman/mason.nvim",
			build = ":MasonUpdate"
		},
		"neovim/nvim-lspconfig",
		"williamboman/mason-lspconfig.nvim",
		{ "ellisonleao/gruvbox.nvim", priority = 1000 }
	}
	, opts)

require("mason").setup()
require("mason-lspconfig").setup()
require("lspconfig").elixirls.setup {}
require("lspconfig").lua_ls.setup {}
vim.o.background = "dark"
vim.wo.number = true
vim.wo.relativenumber = true
vim.o.textwidth = 80
vim.cmd([[colorscheme gruvbox]])
vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.format()]]

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<C-p>', builtin.find_files, {})
vim.keymap.set('n', '<C-q>', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
