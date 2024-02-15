return {
  {
    'folke/trouble.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      auto_preview = false,
    },
    config = function()
      vim.keymap.set(
        'n',
        '<leader>qw',
        '<cmd>TroubleToggle workspace_diagnostics<cr>',
        { silent = true, noremap = true, desc = 'Show diagnostics for workspace' }
      )
      vim.keymap.set(
        'n',
        '<leader>qd',
        '<cmd>TroubleToggle document_diagnostics<cr>',
        { silent = true, noremap = true, desc = 'Show diagnostics for current file' }
      )
      vim.keymap.set('n', '<leader>qq', '<cmd>TroubleToggle quickfix<cr>', { silent = true, noremap = true, desc = 'Show quickfix list' })
      -- vim.keymap.set('n','<leader>ql', '<cmd>TroubleToggle loclist<cr>', { silent = true, noremap = true, desc = 'Show location list' })
      -- vim.keymap.set('n','gR', '<cmd>TroubleToggle lsp_references<cr>', { silent = true, noremap = true, desc = 'Show LSP references in Trouble' })
      -- vim.keymap.set("n", "<leader>qw", function() require("trouble").toggle("workspace_diagnostics") end)
      -- vim.keymap.set("n", "<leader>qf", function() require("trouble").toggle("document_diagnostics") end)
      -- vim.keymap.set('n','<leader>q', '<cmd>TroubleToggle<cr>', { silent = true, noremap = true, desc = 'Show diagnostics' })
    end,
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  },
}
