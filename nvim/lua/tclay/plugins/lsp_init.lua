return {
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPost' },
    dependencies = {
      { 'williamboman/mason.nvim', config = true }, -- Optional
      { 'williamboman/mason-lspconfig.nvim' }, -- Optional
      -- { 'folke/neodev.nvim' },
      {
        'folke/lazydev.nvim',
        ft = 'lua', -- only load on lua files
        opts = {
          library = {
            -- See the configuration section for more details
            -- Load luvit types when the `vim.uv` word is found
            { path = 'luvit-meta/library', words = { 'vim%.uv' } },
          },
        },
      },
      { 'Bilal2453/luvit-meta', lazy = true }, -- optional `vim.uv` typings
      {
        'hrsh7th/nvim-cmp',
        opts = function(_, opts)
          opts.sources = opts.sources or {}
          table.insert(opts.sources, {
            name = 'lazydev',
            group_index = 0, -- set group index to 0 to skip loading LuaLS completions
          })
        end,
      },
      -- Snippet Engine & its associated nvim-cmp source
      { 'L3MON4D3/LuaSnip' },
      { 'saadparwaiz1/cmp_luasnip' },

      { 'rafamadriz/friendly-snippets' },

      -- Adds LSP completion capabilities
      { 'hrsh7th/cmp-nvim-lsp' }, -- Required
      { 'hrsh7th/vim-vsnip' },
      { 'hrsh7th/vim-vsnip-integ' },
    }, -- Required
  },
}
