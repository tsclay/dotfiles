return {
  {
    -- Theme inspired by Atom
    'navarasu/onedark.nvim',
    priority = 0,
  },
  {
    'tsclay/noctis.nvim',
    init = function()
      require('noctis_theme').setup({
        NormalBold = { fg = 'blue', bg = 'none', bold = true },
        NormalItalic = { fg = 'blue', bg = 'none', italic = true },
      }, {
        ['@markup.underline'] = { link = 'Underlined' },
        ['@markup.italic'] = { link = 'NormalItalic' },
        ['@markup.strong'] = { link = 'NormalBold' },
        ['@markup.heading'] = { link = 'Title' },
        ['@markup.raw'] = { link = 'Comment' },
        ['@markup.link'] = { link = 'Identifier' },
        ['@markup.link.url'] = { link = 'helpURL' },
        ['@markup.link.label'] = { link = 'Identifier' },
        ['@markup.list'] = { link = 'Todo' },
      })
    end,
  },
  {
    'lalitmee/cobalt2.nvim',
    event = { 'ColorSchemePre' }, -- if you want to lazy load
    dependencies = { lazy = true, 'tjdevries/colorbuddy.nvim' },
    -- init = function()
    -- require('colorbuddy').colorscheme 'cobalt2'
    -- end,
  },
  { 'catppuccin/nvim', name = 'catppuccin' },
}
-- if vim.api.nvim_command ':colorscheme' == nil or vim.api.nvim_command ':colorscheme' == 'default' then
--   vim.api.nvim_command ':colorscheme noctis_azureus'
-- end
-- adsfasdfasdf
