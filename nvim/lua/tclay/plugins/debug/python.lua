return {
  {
    'mfussenegger/nvim-dap-python',
    build = function()
      local home
      local venv_py
      local py_exe
      -- presumes python is on the path
      if vim.fn.has 'win32' == 1 then
        home = os.getenv 'UserProfile'
        py_exe = vim.fn.exepath 'python.exe'
        venv_py = home .. '/.virtualenvs/debugpy/Scripts/python.exe'
      else
        home = os.getenv 'HOME'
        py_exe = vim.fn.exepath 'python3'
        venv_py = home .. '/.virtualenvs/debugpy/bin/python'
      end
      if vim.fn.isdirectory(home .. '/.virtualenvs') == 0 then
        vim.fn.mkdir(home .. '/.virtualenvs')
      end
      if vim.fn.isdirectory(home .. '/.virtualenvs/debugpy') == 0 then
        -- TODO: Have to find global python exe depending on OS
        vim.fn.system { py_exe, '-m', 'venv', home .. '/.virtualenvs/debugpy' }
        vim.fn.system { venv_py, '-m', 'pip', 'install', 'debugpy' }
      else
        vim.fn.system { venv_py, '-m', 'pip', 'install', 'debugpy', '-U' }
      end
    end,
    config = function()
      local debugpy_path
      if vim.fn.has 'win32' == 1 then
        debugpy_path = os.getenv 'UserProfile' .. '/.virtualenvs/debugpy/Scripts/python.exe'
      else
        debugpy_path = os.getenv 'HOME' .. '/.virtualenvs/debugpy/bin/python'
      end
      require('dap-python').setup(debugpy_path)
    end,
  },
}
