vim.cmd [[ :set foldexpr=nvim_treesitter#foldexpr()]]
vim.o.foldmethod = 'expr'

vim.api.nvim_create_autocmd({ 'BufEnter' }, {
  pattern = { '*.xml', '*.xaml' },
  command = 'normal zx zR',
})
