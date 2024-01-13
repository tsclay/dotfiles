local function split(input, delimiter)
  local arr = {}
  local d = string.gsub(input, '[^' .. delimiter .. ']+', function(w)
    table.insert(arr, w)
  end)
  return arr
end

local function get_venv()
  local t = vim.fn.system[[rg --files --type python]]
  if t == '' then
    return ''
  end
  local venv = require('tclay.utils').get_python_path()
  if venv then
    local params = split(venv, '/\\')
    return '(env:' .. params[#params - 1] .. ')'
  else
    return ''
  end
end

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
