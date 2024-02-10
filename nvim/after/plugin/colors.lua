function ColorMyPencils(color)
  color = string.format('%s', color)
  vim.cmd.colorscheme(color)

  vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
end

function ReloadColorBuddy(color)
  -- Clear all highlighting stuff first then unload the colorbuddy color
  -- Unset transparent_enabled if it's set
  vim.cmd 'hi clear'
  vim.g.transparent_enabled = false
  package.loaded[color] = nil
  -- Borrowed from colorbuddy code to reload the colorscheme
  vim.api.nvim_command 'set termguicolors'
  vim.api.nvim_command(string.format('let g:colors_name = "%s"', color))
  vim.api.nvim_command(string.format('set background=%s', 'dark'))

  local ok = pcall(require, color)
  if not ok then
    vim.api.nvim_command(string.format('colorscheme "%s"', color))
  end
end

vim.api.nvim_create_user_command('LoadColor', function(opts)
  ReloadColorBuddy(opts.fargs[1])
end, { nargs = 1, complete = 'color' })

vim.api.nvim_create_user_command('ColorMyPencils', function(opts)
  ColorMyPencils(opts.fargs[1])
end, { nargs = 1, complete = 'color' })

-- if vim.api.nvim_command ':colorscheme' == nil or vim.api.nvim_command ':colorscheme' == 'default' then
--   vim.api.nvim_command ':colorscheme noctis_azureus'
-- end
-- adsfasdfasdf
