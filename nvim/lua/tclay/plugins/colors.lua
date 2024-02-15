return {
  {
    -- Theme inspired by Atom
    'navarasu/onedark.nvim',
    priority = 0,
  },
  {
    'talha-akram/noctis.nvim',
    -- init = function()
    --   vim.cmd 'colorscheme noctis_azureus'
    --   -- needed for transparent.nvim so that colorscheme is correctly set on toggles
    --   vim.g.colors_name = 'noctis_azureus'
    -- end,
  },
  {
    'lalitmee/cobalt2.nvim',
    event = { 'ColorSchemePre' }, -- if you want to lazy load
    dependencies = { lazy = true, 'tjdevries/colorbuddy.nvim' },
    -- init = function()
    -- require('colorbuddy').colorscheme 'cobalt2'
    -- end,
  },
}
-- if vim.api.nvim_command ':colorscheme' == nil or vim.api.nvim_command ':colorscheme' == 'default' then
--   vim.api.nvim_command ':colorscheme noctis_azureus'
-- end
-- adsfasdfasdf
