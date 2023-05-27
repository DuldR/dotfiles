local lazy = require("lazy")

local plugins = {
	"tpope/vim-commentary",
	"tpope/vim-vinegar",
	"tpope/vim-surround",
	"benmills/vimux",
	"neovim/nvim-lspconfig",
	"vim-test/vim-test",
	"onsails/lspkind-nvim",
	"williamboman/mason-lspconfig.nvim",
	{
	"ellisonleao/gruvbox.nvim",
	-- lazy = Config.theme ~= "gruvbox",
	config = function()
		require("config.theme.gruvbox")
	end

},
	"nvim-treesitter/nvim-treesitter",
	{
		'nvim-telescope/telescope.nvim',
		tag = '0.1.1',
		dependencies = { 'nvim-lua/plenary.nvim' }
	},
		{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lsp-signature-help",
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip"
		},
	},
	"williamboman/mason.nvim",
	build = ":MasonUpdate" -- :MasonUpdate updates registry contents

}

lazy.setup(plugins, opts)
