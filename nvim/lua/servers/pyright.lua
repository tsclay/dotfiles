print('from pyright file ')

return {
  cmd = {
    'pyright-langserver',
    '--stdio',
  },
  settings = {
    python = {
      analysis = {
        typeCheckingMode = 'off',
      },
      pythonPath = require('tclay.utils').get_python_path()
    },
  },
}
