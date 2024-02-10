require('transparent').setup {
  groups = { -- table: default groups
    'Normal',
    'NormalNC',
    'Comment',
    'Constant',
    'Special',
    'Identifier',
    'Statement',
    'PreProc',
    'Type',
    'Underlined',
    'Todo',
    'String',
    'Function',
    'Conditional',
    'Repeat',
    'Operator',
    'Structure',
    'LineNr',
    'NonText',
    'SignColumn',
    'CursorLineNr',
    'EndOfBuffer',
    -- below are from default config
    'CursorLine',
    'StatusLine',
    'StatusLineNC',
  },
  extra_groups = {
    -- 'NormalFloat', -- plugins which have float panel such as Lazy, Mason, LspInfo
    -- 'NvimTreeNormal', -- NvimTree
  },
  exclude_groups = {}, -- table: groups you don't want to clear
}

vim.api.nvim_command 'set shortmess=I'

-- local state = "false"
-- local cache = assert(io.open(vim.fn.stdpath('data') .. '/transparent_cache'), 'r')
-- if cache ~= nil then
--   state = cache:read '*a'
--   cache:close()
-- end
-- print('state is ', state)
-- if state == "true" then
--   vim.cmd[[:TransparentEnable]]
-- end
