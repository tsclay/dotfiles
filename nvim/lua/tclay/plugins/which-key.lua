-- local M = {}

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

-- local function normal_keymap()
--   local keymap = {
--
--     -- Database
--     D = {
--       name = 'Database',
--       u = { '<Cmd>DBUIToggle<Cr>', 'Toggle UI' },
--       f = { '<Cmd>DBUIFindBuffer<Cr>', 'Find buffer' },
--       r = { '<Cmd>DBUIRenameBuffer<Cr>', 'Rename buffer' },
--       q = { '<Cmd>DBUILastQueryInfo<Cr>', 'Last query info' },
--       h = { '<Cmd>DBUIHideNotifications<Cr>', 'Hide notifications'}
--     },
--   }
--   whichkey.register(keymap, opts)
-- end
--
-- function M.setup()
--   normal_keymap()
-- end

return {
  {
    'folke/which-key.nvim',
    event = "VeryLazy",
    opts = {},
    keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
    -- config = function()
    --   local whichkey = require 'which-key'
    --
    --   local conf = {
    --     win = {
    --       border = 'single', -- none, single, double, shadow
    --       -- position = 'bottom', -- bottom, top
    --     },
    --   }
    --   whichkey.setup(conf)
    --   whichkey.add {
    --
    --     -- Database
    --     { '<leader>D', group = 'Database', nowait = false, remap = false, mode = 'n' },
    --     { '<leader>Df', '<Cmd>DBUIFindBuffer<Cr>', desc = 'Find buffer', nowait = false, remap = false, mode = 'n' },
    --     { '<leader>Dh', '<Cmd>DBUIHideNotifications<Cr>', desc = 'Hide notifications', nowait = false, remap = false, mode = 'n' },
    --     { '<leader>Dq', '<Cmd>DBUILastQueryInfo<Cr>', desc = 'Last query info', nowait = false, remap = false, mode = 'n' },
    --     { '<leader>Dr', '<Cmd>DBUIRenameBuffer<Cr>', desc = 'Rename buffer', nowait = false, remap = false, mode = 'n' },
    --     { '<leader>Du', '<Cmd>DBUIToggle<Cr>', desc = 'Toggle UI', nowait = false, remap = false, mode = 'n' },
    --   }
    -- end,
  },
}
