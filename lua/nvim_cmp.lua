-- Setup nvim-cmp.
local cmp = require'cmp'

cmp.setup({
    mapping = {
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<C-d>'] = cmp.mapping.scroll_docs(4),
        ['<C-t>'] = cmp.mapping.complete(),
        ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's' }),
        ['<C-e>'] = cmp.mapping.close(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
    },
    sources = {
        { name = 'nvim_lsp' },
         { name = 'path' },
         --{ name = 'zsh' },
         { name = 'nvim_lua' },

       { name = 'nvim_cpp' },
       { name = 'ultisnips' },
       { name = 'calc' },

      { name = 'buffer' },
    }
  })

--require'cmp'.setup.cmdline(':', {
    --sources = {
        --{ name = 'cmdline' }
    --}
--})

cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

