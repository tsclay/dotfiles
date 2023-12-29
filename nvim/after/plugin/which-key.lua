local M = {}

local whichkey = require 'which-key'

local conf = {
  window = {
    border = 'single', -- none, single, double, shadow
    position = 'bottom', -- bottom, top
  },
}
whichkey.setup(conf)

local opts = {
  mode = 'n', -- Normal mode
  prefix = '<leader>',
  buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
  silent = true, -- use `silent` when creating keymaps
  noremap = true, -- use `noremap` when creating keymaps
  nowait = false, -- use `nowait` when creating keymaps
}

local v_opts = {
  mode = 'v', -- Visual mode
  prefix = '<leader>',
  buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
  silent = true, -- use `silent` when creating keymaps
  noremap = true, -- use `noremap` when creating keymaps
  nowait = false, -- use `nowait` when creating keymaps
}

local function normal_keymap()
  local keymap = {

    -- Database
    D = {
      name = 'Database',
      u = { '<Cmd>DBUIToggle<Cr>', 'Toggle UI' },
      f = { '<Cmd>DBUIFindBuffer<Cr>', 'Find buffer' },
      r = { '<Cmd>DBUIRenameBuffer<Cr>', 'Rename buffer' },
      q = { '<Cmd>DBUILastQueryInfo<Cr>', 'Last query info' },
      h = { '<Cmd>DBUIHideNotifications<Cr>', 'Hide notifications'}
    },
  }
  whichkey.register(keymap, opts)
end

function M.setup()
  normal_keymap()
end

return M
