local lazy = require("lazy")

local plugins = {
	"tpope/vim-commentary",
	"tpope/vim-vinegar",
	"tpope/vim-surround",
	"tpope/vim-fugitive",
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
	-- For manjaro
	{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
	-- { 'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' },
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
			dependencies = { "rafamadriz/friendly-snippets" },
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
	{
		"epwalsh/obsidian.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			require("config.obsidian")
		end
	},
	{
		'nvim-tree/nvim-web-devicons',
		config = function()
			require("config.devicons")
		end
	},
	{
		"toppair/peek.nvim",
		event = { "VeryLazy" },
		build = "deno task --quiet build:fast",
		config = function()
			require("peek").setup(
				{
					app = { "firefox", "--new-window" }
				}
			)
			vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
			vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
		end,
	},
}

lazy.setup(plugins, opts)
