local parsers = { "bash", "eex", "elixir", "heex", "javascript", "json", "yaml" }

  require("nvim-treesitter").install(parsers)

  vim.api.nvim_create_autocmd("FileType", {
    pattern = vim.list_extend(vim.deepcopy(parsers), { "markdown", "markdown_inline" }),
    callback = function(ev)
      pcall(vim.treesitter.start, ev.buf)
      vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
  })
