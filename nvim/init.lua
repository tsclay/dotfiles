local cdpwd = vim.api.nvim_create_augroup('cdpwd', { clear = true })
vim.api.nvim_create_autocmd('VimEnter', {
  group = cdpwd,
  callback = function(data)
    local dir = string.match(data.file, '^[a-z]+://(.+)$') or data.file
    if dir == nil then
      return
    end
    if vim.fn.isdirectory(dir) == 0 then
      dir = vim.fn.fnamemodify(dir, ':h')
    end
    vim.api.nvim_set_current_dir(dir)
  end,
})

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.title = true
vim.opt.titlestring = [[%t – %{fnamemodify(getcwd(), ':t')}]]
-- vim.g.db_ui_use_nerd_fonts = 1
-- vim.g.db_ui_dotenv_variable_prefix = 'DATABASE_URL_'
-- vim.g.db_ui_execute_on_save = 0

require 'tclay'
-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
