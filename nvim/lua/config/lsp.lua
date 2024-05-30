require("mason").setup()
require("mason-lspconfig").setup()


vim.api.nvim_create_autocmd('LspAttach', {
	desc = 'LSP actions',
	callback = function()
		local bufmap = function(mode, lhs, rhs)
			local opts = { buffer = true }
			vim.keymap.set(mode, lhs, rhs, opts)
		end

		bufmap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>')
		bufmap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>')
		bufmap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>')
		bufmap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>')
		bufmap('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>')
		bufmap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>')
		bufmap('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>')
		bufmap('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>')
		bufmap('n', '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>')
		bufmap('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>')
		bufmap('x', '<F4>', '<cmd>lua vim.lsp.buf.range_code_action()<cr>')
		bufmap('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>')
		bufmap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>')
		bufmap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>')
	end
})


local lspconfig = require('lspconfig')
local configs = require("lspconfig.configs")
local lsp_defaults = lspconfig.util.default_config

lsp_defaults.capabilities = vim.tbl_deep_extend(
	'force',
	lsp_defaults.capabilities,
	require('cmp_nvim_lsp').default_capabilities()
)

-- lspconfig.elixirls.setup({})
lspconfig.tsserver.setup({})
lspconfig.marksman.setup({})
lspconfig.gopls.setup({
	settings = {
		gopls = {
			analyses = {
				unusedparams = true,
			},
			staticcheck = true,
			gofumpt = true,
		},
	},
})

local lexical_config = {
	filetypes = { "elixir", "eelixir", "heex" },
	cmd = { "/Documents/scratch/git/lexical/_build/dev/package/lexical/bin/start_lexical.sh" },
	settings = {},
}

if not configs.lexical then
	configs.lexical = {
		default_config = {
			filetypes = lexical_config.filetypes,
			cmd = lexical_config.cmd,
			root_dir = function(fname)
				return lspconfig.util.root_pattern("mix.exs", ".git")(fname) or vim.loop.os_homedir()
			end,
			-- optional settings
			settings = lexical_config.settings,
		},
	}
end

lspconfig.lexical.setup({})

lspconfig.lua_ls.setup({
	settings =
	{
		Lua = {
			diagnostics = {
				globals = { 'vim' }
			}
		}
	}
})

vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

require('luasnip.loaders.from_vscode').lazy_load()

local cmp = require('cmp')
local luasnip = require('luasnip')

local select_opts = { behavior = cmp.SelectBehavior.Select }

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end
	},
	sources = {
		{ name = 'path' },
		{ name = 'nvim_lsp', keyword_length = 1 },
		{ name = 'buffer',   keyword_length = 3 },
		{ name = 'luasnip',  keyword_length = 2 },
	},
	window = {
		documentation = cmp.config.window.bordered()
	},
	formatting = {
		fields = { 'menu', 'abbr', 'kind' },
		format = function(entry, item)
			local menu_icon = {
				nvim_lsp = 'λ',
				luasnip = '⋗',
				buffer = 'Ω',
				path = '🖫',
			}

			item.menu = menu_icon[entry.source.name]
			return item
		end,
	},
	mapping = {
		['<Up>'] = cmp.mapping.select_prev_item(select_opts),
		['<Down>'] = cmp.mapping.select_next_item(select_opts),

		['<C-p>'] = cmp.mapping.select_prev_item(select_opts),
		['<C-n>'] = cmp.mapping.select_next_item(select_opts),

		['<C-u>'] = cmp.mapping.scroll_docs(-4),
		['<C-d>'] = cmp.mapping.scroll_docs(4),

		['<C-e>'] = cmp.mapping.abort(),
		['<C-y>'] = cmp.mapping.confirm({ select = true }),
		['<CR>'] = cmp.mapping.confirm({ select = false }),

		['<C-f>'] = cmp.mapping(function(fallback)
			if luasnip.jumpable(1) then
				luasnip.jump(1)
			else
				fallback()
			end
		end, { 'i', 's' }),

		['<C-b>'] = cmp.mapping(function(fallback)
			if luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { 'i', 's' }),

		['<Tab>'] = cmp.mapping(function(fallback)
			local col = vim.fn.col('.') - 1

			if cmp.visible() then
				cmp.select_next_item(select_opts)
			elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
				fallback()
			else
				cmp.complete()
			end
		end, { 'i', 's' }),

		['<S-Tab>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item(select_opts)
			else
				fallback()
			end
		end, { 'i', 's' }),
	},
})
