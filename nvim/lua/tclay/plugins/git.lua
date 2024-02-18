-- vim.keymap.set("n", "<leader>gs", vim.cmd.Git)
vim.keymap.set('n', '<leader>gs', '<cmd>:tab Git<CR>', { desc = 'Open Git status in new tab' })

local my_fugitive = vim.api.nvim_create_augroup('my_fugitive', {})

vim.api.nvim_create_autocmd('BufWinEnter', {
  group = my_fugitive,
  pattern = '*',
  callback = function()
    if vim.bo.ft ~= 'fugitive' then
      return
    end

    local bufnr = vim.api.nvim_get_current_buf()
    local opts = { buffer = bufnr, remap = false }
    opts.desc = 'git push'
    vim.keymap.set('n', '<leader>gp', function()
      vim.cmd.Git 'push'
    end, opts)

    -- rebase always
    opts.desc = 'git pull --rebase'
    vim.keymap.set('n', '<leader>gP', function()
      vim.cmd.Git 'pull --rebase'
    end, opts)

    -- NOTE: It allows me to easily set the branch i am pushing and any tracking
    -- needed if i did not set the branch up correctly
    opts.desc = 'git push -u origin'
    vim.keymap.set('n', '<leader>t', ':Git push -u origin<CR>', opts)

    opts.desc = 'Undo commit'
    vim.keymap.set('n', '<leader>gC', ':Git reset --soft HEAD~<CR>', opts)
  end,
})

return {
  { 'tpope/vim-fugitive' },
  { 'tpope/vim-rhubarb' },
  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    event = 'VeryLazy',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        vim.keymap.set('n', '<leader>gp', require('gitsigns').prev_hunk, { buffer = bufnr, desc = '[G]o to [P]revious Hunk' })
        vim.keymap.set('n', '<leader>gn', require('gitsigns').next_hunk, { buffer = bufnr, desc = '[G]o to [N]ext Hunk' })
        vim.keymap.set('n', '<leader>ph', require('gitsigns').preview_hunk, { buffer = bufnr, desc = '[P]review [H]unk' })
      end,
    },
  },
}
