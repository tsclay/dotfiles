return {
  {
    'folke/todo-comments.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      highlight = {
        keyword = '',
        after = '',
      },
    },
    init = function()
      vim.keymap.set('n', '<leader>qt', ':TodoTrouble<CR>', { silent = true, noremap = true, desc = 'Open Todo list with Trouble' })
      vim.keymap.set('n', '<leader>pt', ':TodoTelescope<CR>', { silent = true, noremap = true, desc = 'Open Todo list with Telescope' })
    end,
  },
}
