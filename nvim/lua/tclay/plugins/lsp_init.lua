return {
    {
      'neovim/nvim-lspconfig',
      dependencies = {
        { 'williamboman/mason.nvim', config = true }, -- Optional
        { 'williamboman/mason-lspconfig.nvim' }, -- Optional
        { 'folke/neodev.nvim' },
        { 'hrsh7th/nvim-cmp' },
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
