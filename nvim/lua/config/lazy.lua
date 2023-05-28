local lazy = require("lazy")

local plugins = {
	"tpope/vim-commentary",
	"tpope/vim-vinegar",
	"tpope/vim-surround",
	"benmills/vimux",
	"vim-test/vim-test",
	"onsails/lspkind-nvim",
	{
	"ellisonleao/gruvbox.nvim",
	lazy = Config.theme ~= "gruvbox",
	config = function()
		require("config.theme.gruvbox")
	end

},
	{
	"folke/tokyonight.nvim",
	lazy = Config.theme ~= "tokyonight",
	config = function()
		require("config.theme.tokyonight")
	end

},
{
	"nvim-treesitter/nvim-treesitter",
	config = function()
		require("config.nvim-treesitter")
	end
},
	{
		'nvim-telescope/telescope.nvim',
		dependencies = {
			"nvim-lua/plenary.nvim"
		},
		config = function()
			require("config.telescope")
		end
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
			"hrsh7th/cmp-vsnip",
			"hrsh7th/vim-vsnip",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip"
		},
		config = function()
			require("config.nvim-cmp")
		end
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason-lspconfig.nvim"
		},
		config = function()
			require("config.lsp")
		end
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			"mason.nvim"
		}
	},
	{
		"williamboman/mason.nvim",
		build = function()
		pcall(function()
require("mason-registry").refresh()
end)
		end
	},
}

lazy.setup(plugins, opts)
