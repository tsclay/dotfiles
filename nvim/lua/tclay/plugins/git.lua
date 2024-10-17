vim.keymap.set('n', '<leader>gs', '<cmd>:tab Git<CR>', { desc = 'Open Git status in new tab' })
vim.keymap.set('n', '<leader>glh', '<cmd>:Git log HEAD<CR>', { desc = 'Open Git log at HEAD' })

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

    opts.desc = 'Show commits of current branch against default'
    vim.keymap.set('n', '<leader>gld', function()
      local git_check = vim.fn.finddir('.git', vim.fn.getcwd() .. ';')
      if git_check == '' then
        print 'Not in a Git repository'
        return
      end
      local current_branch = vim.fn.system 'git rev-parse --abbrev-ref HEAD'
      current_branch = string.gsub(current_branch, '%s', '')

      local default_branch = vim.fn.system 'git symbolic-ref refs/remotes/origin/HEAD --short'
      if default_branch:find 'fatal' ~= nil then
        default_branch = 'origin/main'
      end
      default_branch = string.gsub(default_branch, '%s', '')

      print(':Git ' .. 'log ^' .. default_branch .. ' ' .. current_branch)
      vim.cmd.Git('log ^' .. default_branch .. ' ' .. current_branch)
    end, opts)

    opts.desc = 'Show commits of current branch against upstream'
    vim.keymap.set('n', '<leader>glu', function()
      local git_check = vim.fn.finddir('.git', vim.fn.getcwd() .. ';')
      if git_check == '' then
        print 'Not in a Git repository'
        return
      end
      local current_branch = vim.fn.system 'git rev-parse --abbrev-ref HEAD'
      current_branch = string.gsub(current_branch, '%s', '')

      local tracking_branch = vim.fn.system 'git rev-parse --abbrev-ref HEAD@{u}'
      tracking_branch = string.gsub(tracking_branch, '%s', '')

      print(':Git ' .. 'log ^' .. tracking_branch .. ' ' .. current_branch)
      vim.cmd.Git('log ^' .. tracking_branch .. ' ' .. current_branch)
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
        vim.keymap.set('n', '<leader>glb', '<cmd>:Git blame<CR>', { desc = 'Open Git blame' })
        vim.keymap.set('n', '<leader>glf', function()
          local filename = vim.api.nvim_buf_get_name(0)
          local cmd = 'log -p -- ' .. filename
          print(cmd)
          vim.cmd.Git(cmd)
        end, { desc = 'Open Git history of current file' })
      end,
    },
  },
}
