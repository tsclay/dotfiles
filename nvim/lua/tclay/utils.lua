local M = {}

function M.dump(o)
  if type(o) == 'table' then
    local s = '{ '
    for k, v in pairs(o) do
      if type(k) ~= 'number' then
        k = '"' .. k .. '"'
      end
      s = s .. '[' .. k .. '] = ' .. M.dump(v) .. ','
    end
    return s .. '} '
  else
    return tostring(o)
  end
end

function M.dirname(path)
  -- local strip_dir_pat = '/([^/]+)$'
  local strip_dir_pat = '([^/\\]+)$'
  local strip_sep_pat = '[/\\]$'
  if not path or #path == 0 then
    return
  end
  -- print('the path before ', path)
  local result = path:gsub(strip_sep_pat, ''):gsub(strip_dir_pat, '')
  -- print(path:gsub(strip_sep_pat, ''))
  -- print('the result ', result)
  if #result == 0 then
    if vim.fn.has 'win32' then
      return path:sub(1, 2):upper()
    else
      return '/'
    end
  end
  return result
end

function M.get_python_path()
  local root_files = {
    'pyproject.toml',
    'setup.py',
    'setup.cfg',
    'requirements.txt',
    'Pipfile',
    'pyrightconfig.json',
    '.git',
  }
  local workspace = M.get_root(root_files)
  local path = require('lspconfig.util').path

  -- Find and use virtualenv in workspace directory.
  for _, pattern in ipairs { '*', '.*' } do
    local match = vim.fn.glob(path.join(workspace:gsub('[/\\]$', ''), pattern, 'pyvenv.cfg'))
    -- print(match)
    if match ~= '' then
      if vim.fn.has 'win32' == 1 then
        return M.dirname(match) .. 'Scripts' .. '/python.exe'
      else
        return path.join(M.dirname(match), 'bin', 'python')
      end
    end
  end

  -- Use activated virtualenv.
  if vim.env.VIRTUAL_ENV then
    -- print 'Using virtualenv that was sourced'
    if vim.fn.has 'win32' == 1 then
      return path.join(vim.env.VIRTUAL_ENV, 'Scripts', 'python.exe')
    else
      return path.join(vim.env.VIRTUAL_ENV, 'bin', 'python')
    end
  end

  -- Fallback to system Python.
  if vim.fn.has 'win32' == 1 then
    return vim.fn.exepath 'python.exe'
  else
    return vim.fn.exepath 'python3'
  end
end

function M.get_root(...)
  local filename = vim.fn.fnameescape(vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':p'))
  local filepath
  local primary = require('lspconfig.util').root_pattern(...)
  if vim.fn.isdirectory(filename) then
    filepath = filename
  else
    filepath = M.dirname(filename)
  end
  -- print('the filepath ', filepath)
  return primary and primary(filepath) or ''
end

return M
