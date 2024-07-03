return {
  { 'tpope/vim-dotenv', lazy = false },
  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',
  {
    'RRethy/vim-illuminate',
    -- cmd = "IlluminateToggle",
    -- keys = {
    --   -- { "<leader>ti", require("illuminate").toggle(), "[T]oggle [I]lluminate" }
    --   { "<leader>ti", "<cmd>IlluminateToggle<CR>", "[T]oggle [I]lluminate" },
    -- },
    opts = {
      -- filetypes_denylist = {
      --   "dirvish",
      --   "fugitive",
      --   "md",
      --   "org",
      --   "norg",
      --   "NvimTree",
      -- },
    },
    config = function(opts)
      require('illuminate').configure {
        filetypes_denylist = {
          'fugitive',
          'org',
          'norg',
          'NvimTree',
        },
      }

      vim.keymap.set('n', '<leader>ti', '<cmd>IlluminateToggle<CR>', { desc = '[T]oggle [I]lluminate' })
      vim.keymap.set('n', '<leader>tf', require('illuminate').toggle_freeze_buf, { desc = '[F]reeze Illuminate' })
    end,
  },
  -- { 'akinsho/bufferline.nvim', version = '*', dependencies = 'nvim-tree/nvim-web-devicons' },

  -- { 'nvim-lualine/lualine.nvim' },
  -- {
  --   'mbbill/undotree',
  -- },
  { 'lukas-reineke/indent-blankline.nvim', main = 'ibl', opts = {} },

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },
  { 'JoosepAlviste/nvim-ts-context-commentstring' },
  {
    'windwp/nvim-autopairs',
    -- Optional dependency
    dependencies = { 'hrsh7th/nvim-cmp' },
    config = function()
      require('nvim-autopairs').setup {}
      -- If you want to automatically add `(` after selecting a function or method
      local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
      local cmp = require 'cmp'
      cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
    end,
  },
  'windwp/nvim-ts-autotag',
  -- Useful plugin to show you pending keybinds.
  -- { 'folke/which-key.nvim', opts = {} },
  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    ft = { 'markdown' },
    build = function()
      vim.fn['mkdp#util#install']()
    end,
    init = function()
      -- Open Markdown Preview when entering a .md file
      -- vim.g.mkdp_auto_start = 1
      -- Don't close the preview when moving away from .md buffer
      vim.g.mkdp_auto_close = 0
    end,
  },
}
