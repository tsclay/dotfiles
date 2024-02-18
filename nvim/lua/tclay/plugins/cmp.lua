return {
  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    event = { 'BufReadPost', 'BufNewFile' },
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'rafamadriz/friendly-snippets',
      'onsails/lspkind.nvim',
      'hrsh7th/vim-vsnip-integ',
      'hrsh7th/vim-vsnip',
    },
    config = function()
      -- [[ Configure nvim-cmp ]]
      -- See `:help cmp`
      local cmp = require 'cmp'
      local lspkind = require 'lspkind'

      local luasnip = require 'luasnip'
      -- require('luasnip.loaders.from_vscode').lazy_load()
      -- luasnip.config.setup {}

      local function formatForTailwindCSS(entry, vim_item)
        if vim_item.kind == 'Color' and entry.completion_item.documentation then
          local _, _, r, g, b = string.find(entry.completion_item.documentation, '^rgb%((%d+), (%d+), (%d+)')
          if r then
            local color = string.format('%02x', r) .. string.format('%02x', g) .. string.format('%02x', b)
            local group = 'Tw_' .. color
            if vim.fn.hlID(group) < 1 then
              vim.api.nvim_set_hl(0, group, { fg = '#' .. color })
            end
            vim_item.kind = '●'
            vim_item.kind_hl_group = group
            return vim_item
          end
        end
        vim_item.kind = lspkind.symbolic(vim_item.kind) and lspkind.symbolic(vim_item.kind) or vim_item.kind
        return vim_item
      end

      cmp.setup {
        enabled = true,
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert {
          ['<C-p>'] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Select },
          ['<C-n>'] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Select },
          ['<C-y>'] = cmp.mapping.confirm { select = true },
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-e>'] = cmp.mapping.close(),
          ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          },
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
          { name = 'buffer' },
        },
        -- formatting = {
        --   format = function(entry, vim_item)
        --     if vim.tbl_contains({ 'path' }, entry.source.name) then
        --       local icon, hl_group = require('nvim-web-devicons').get_icon(entry:get_completion_item().label)
        --       if icon then
        --         vim_item.kind = icon
        --         vim_item.kind_hl_group = hl_group
        --         return vim_item
        --       end
        --     end
        --     return require('lspkind').cmp_format({ with_text = false })(entry, vim_item)
        --   end
        -- }
        formatting = {
          expandable_indicator = true,
          format = lspkind.cmp_format {
            mode = 'symbol_text', -- show only symbol annotations
            maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
            ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
            menu = {
              buffer = '[Buffer]',
              nvim_lsp = '[LSP]',
              luasnip = '[LuaSnip]',
              nvim_lua = '[Lua]',
              latex_symbols = '[Latex]',
            },
            -- The function below will be called before any actual modifications from lspkind
            -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
            before = function(entry, vim_item)
              vim_item = formatForTailwindCSS(entry, vim_item)
              return vim_item
            end,
          },
        },
      }

      -- ...
      -- Use buffer source for `/`
      cmp.setup.cmdline('/', {
        sources = {
          { name = 'buffer' },
        },
      })

      -- Use cmdline & path source for ':'
      cmp.setup.cmdline(':', {
        sources = cmp.config.sources({
          { name = 'path' },
        }, {
          { name = 'cmdline' },
        }),
      })
      -- ...
      vim.cmd [[
  set completeopt=menuone,noinsert,noselect
  highlight! default link CmpItemKind CmpItemMenuDefault
]]
    end,
  },
}
