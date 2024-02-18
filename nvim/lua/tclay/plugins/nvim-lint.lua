vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client.name ~= 'pyright' then
      return
    end
    local py_exe = client.config.settings.python.pythonPath
    if py_exe == nil or py_exe == '' then
      return
    end

    local lint = require 'lint'

    local mypy = lint.linters.mypy
    -- check if buffer has name
    -- if no name, need to get the contents and feed into mypy via '-c'
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

    lint.try_lint { 'mypy' }
  end,
})

return {
  {
    'mfussenegger/nvim-lint',
  },
}
