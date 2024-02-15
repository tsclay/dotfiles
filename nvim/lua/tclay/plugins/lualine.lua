-- local function split(input, delimiter)
--   local arr = {}
--   local d = string.gsub(input, '[^' .. delimiter .. ']+', function(w)
--     table.insert(arr, w)
--   end)
--   return arr, d
-- end
local get_python_path = require('tclay.utils').get_python_path
local dirname = require('tclay.utils').dirname

local t = ''
local function get_venv()
  -- if vim.fn.getcwd() ~= os.getenv('HOME') then
  --   local t = vim.fn.system [[rg --files --type python]]
  -- end
  -- if t == '' then
  --   return ''
  -- end
  -- print('t is ', t)
  if next(vim.lsp.get_active_clients { name = 'pyright' }) == nil then
    return ''
  end
  local filename = vim.api.nvim_buf_get_name(0)
  local py_root = vim.lsp.get_active_clients({ name = 'pyright' })[1].config.cmd_cwd
  if t ~= '' and string.find(filename, py_root, 1, true) ~= nil then
    print 'hooray!'
    return t
  elseif t ~= '' then
    print 'hooray kinda!'
    return '  ' .. t
  end

  print 'boooooooooo'
  -- print('we gotta check again')
  -- check if 't' matches pwd, if so return 't'
  local venv = get_python_path()
  if venv then
    local version = vim.fn.system { venv, '--version' }
    version = version:gsub('[^A-Za-z0-9. ]+', '')
    local path_str = dirname(venv)
    if path_str ~= nil then
      path_str = path_str:gsub('[\\/]$', '')
    end
    -- local params, path_str = split(venv, '/\\')
    -- return 'env:' .. params[#params - 1] .. ')'
    t = version .. ' (' .. path_str .. ')'
    return version .. ' (' .. path_str .. ')'
  else
    return ''
  end
end

return {

  {
    'nvim-lualine/lualine.nvim',
    config = function()
      require('lualine').setup {
        options = {
          icons_enabled = true,
          theme = 'auto',
          component_separators = { left = '', right = '' },
          section_separators = { left = '', right = '' },
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'branch', 'diff', 'diagnostics' },
          lualine_c = { 'filename' },
          lualine_x = { 'encoding', 'fileformat', 'filetype' },
          lualine_y = { { get_venv, color = { fg = '#97C379', gui = 'bold' } } },
          lualine_z = { 'location' },
        },
      }
    end,
  },
}
