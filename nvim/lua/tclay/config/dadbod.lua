local M = {}

local function db_completion()
  require('cmp').setup.buffer { sources = { { name = 'vim-dadbod-completion' } } }
end

-- local function opts(desc)
-- return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
-- end
local function find_db_env()
  if vim.g.db_ui_save_location and vim.fn.exists(vim.g.db_ui_save_location) then
    -- dotenv load here
    local env_file = vim.fs.find('.env', {
      upward = false,
      path = vim.g.db_ui_save_location,
      type = 'file',
    })
    local size = 0
    for _ in pairs(env_file) do
      size = size + 1
    end
    if size == 0 or size > 1 then
      print("aint find nothing")
      return
    end
    env_file = env_file[1]
    print 'loading env_file'
    vim.cmd('Dotenv ' .. env_file)
  end
end

function M.setup()
  vim.api.nvim_create_autocmd('FileType', {
    pattern = {
      'sql',
    },
    command = [[setlocal omnifunc=vim_dadbod_completion#omni]],
  })

  vim.api.nvim_create_autocmd('FileType', {
    pattern = {
      'sql',
      'mysql',
      'plsql',
    },
    callback = function()
      vim.schedule(db_completion)
    end,
  })
  find_db_env()
  -- vim.keymap.set('n', 'u', '<Cmd>DBUIToggle<Cr>', opts 'Toggle UI')
  -- vim.keymap.set('n', 'f', '<Cmd>DBUIFindBuffer<Cr>', opts 'Find buffer')
  -- vim.keymap.set('n', 'r', '<Cmd>DBUIRenameBuffer<Cr>', opts 'Rename buffer')
  -- vim.keymap.set('n', 'q', '<Cmd>DBUILastQueryInfo<Cr>', opts 'Last query info')
end

return M
