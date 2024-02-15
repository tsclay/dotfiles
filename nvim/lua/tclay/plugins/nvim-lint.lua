vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
  callback = function()
    if vim.bo.filetype == 'python' then
      require('lint').try_lint { 'mypy' }
    end
  end,
})

return {
  {
    'mfussenegger/nvim-lint',
    config = function()
      local lint = require 'lint'
      print('inside lint.lua')
      local py_exe = require('tclay.utils').get_python_path()

      local mypy = lint.linters.mypy
      mypy.args = {
        '--python-executable',
        py_exe,
        '--show-column-numbers',
        '--hide-error-context',
        '--no-color-output',
        '--no-error-summary',
        '--no-pretty',
        '--ignore-missing-imports',
        '--disallow-untyped-defs',
      }
      local groups = { 'file', 'lnum', 'col', 'severity', 'message', 'code' }
      local severities = {
        error = vim.diagnostic.severity.ERROR,
        warning = vim.diagnostic.severity.WARN,
        note = vim.diagnostic.severity.HINT,
      }
      local pat = '([^:]+):(%d+):(%d+): (%a+): (.*)  %[([%a-]+)'
      mypy.parser = require('lint.parser').from_pattern(pat, groups, severities, { ['source'] = 'mypy' }, { end_col_offset = 0 })

      lint.linters_by_ft = {
        python = { 'mypy' },
      }
    end,
  },
}
