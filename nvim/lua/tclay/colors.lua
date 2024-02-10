function ColorMyPencils(color)
  color = string.format('%s', color)
  vim.cmd.colorscheme(color)

  vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
end

function SetColorScheme(color)
  local ok = pcall(require, color)
  if ok then
    vim.cmd.colorscheme(color)
    vim.g.colors_name = color
  else
    -- Clear all highlighting stuff first then unload the colorbuddy color
    -- Unset transparent_enabled if it's set
    vim.cmd 'hi clear'
    vim.g.transparent_enabled = false
    package.loaded[color] = nil
    -- Borrowed from colorbuddy code to reload the colorscheme
    vim.api.nvim_command 'set termguicolors'
    vim.cmd.colorscheme(color)
    vim.g.colors_name = color
  end
  local set_theme = assert(io.open(vim.fn.stdpath 'data' .. '/colorscheme.cache', 'w'))
  set_theme:write(color)
  set_theme:close()
end

vim.api.nvim_create_user_command('Theme', function(opts)
  SetColorScheme(opts.fargs[1])
end, { nargs = 1, complete = 'color' })

vim.api.nvim_create_user_command('ColorMyPencils', function(opts)
  ColorMyPencils(opts.fargs[1])
end, { nargs = 1, complete = 'color' })

-- if vim.api.nvim_command ':colorscheme' == nil or vim.api.nvim_command ':colorscheme' == 'default' then
--   vim.api.nvim_command ':colorscheme noctis_azureus'
-- end
local color = 'default'
local set_theme = io.open(vim.fn.stdpath 'data' .. '/colorscheme.cache', 'r')
if set_theme then
  color = set_theme:read '*a'
  -- print('gonna set ', color, #color)
  -- vim.cmd.colorscheme(color)
  -- set_theme:close()
end
-- vim.api.nvim_command(string.format('colorscheme "%s"', color))
SetColorScheme(color)
