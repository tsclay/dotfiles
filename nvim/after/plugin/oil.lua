vim.api.nvim_create_autocmd('FileType', {
  pattern = 'oil',
  callback = function()
    vim.opt_local.colorcolumn = ''
  end,
})

require('oil').setup {
  keymaps = {
    ['g?'] = 'actions.show_help',
    ['<CR>'] = 'actions.select',
    ['<C-]>'] = 'actions.select_vsplit',
    ['<C-enter>'] = 'actions.select_split', -- this is used to navigate left
    ['<C-t>'] = 'actions.select_tab',
    ['<C-p>'] = 'actions.preview',
    ['<C-c>'] = 'actions.close',
    ['<C-r>'] = 'actions.refresh',
    ['-'] = 'actions.parent',
    ['_'] = 'actions.open_cwd',
    ['`'] = 'actions.cd',
    ['~'] = 'actions.tcd',
    ['gs'] = 'actions.change_sort',
    ['gx'] = 'actions.open_external',
    ['g.'] = 'actions.toggle_hidden',
    ['P'] = 'actions.copy_entry_path',
  },
  use_default_keymaps = false,
  view_options = {
    show_hidden = true,
    is_always_hidden = function(name, bufnr)
      return name == '..'
    end,
  },
}

vim.keymap.set('n', '<leader>o', require('oil').toggle_float, { desc = '[o] Toggle Oil buffer in floating window' })

--[[ gx      Open the entry under the cursor in an external program
 g\      Jump to and from the trash for the current directory
 _       Open oil in Neovim's current working directory
 gs      Change the sort order
 -       Navigate to the parent path
 `       :cd to the current oil directory
 g?      Show default keymaps
 ~       :tcd to the current oil directory
 <C-p>   Open the entry under the cursor in a preview window, or close the preview window if already open
 <CR>    Open the entry under the cursor
 <C-t>   Open the entry under the cursor in a new tab
 <C-c>   Close oil and restore original buffer
 g.      Toggle hidden files and directories
 <C-s>   Open the entry under the cursor in a vertical split
 <C-h>   Open the entry under the cursor in a horizontal split
 <C-l>   Refresh current directory list ]]
