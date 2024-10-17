vim.api.nvim_create_autocmd({ 'InsertLeave', 'BufWrite' }, {
    callback = function ()
        if vim.bo.filetype ~= 'python' then
            return
        end
        require('lint').try_lint { 'mypy' }
    end
})

    -- if vim.bo.filetype ~= 'python' then
    --   return
    -- end
    -- print 'hello python'
    -- local lint = require 'lint'
    -- local py_exe = vim.lsp.get_active_clients({ name = 'pyright' })[1].config.settings.python.pythonPath
    -- print('the py_exe ', py_exe)
    --
    -- local mypy = lint.linters.mypy
    -- mypy.args = {
    --   '--python-executable',
    --   py_exe,
    --   '--show-column-numbers',
    --   '--hide-error-context',
    --   '--no-color-output',
    --   '--no-error-summary',
    --   '--no-pretty',
    --   '--ignore-missing-imports',
    --   '--disallow-untyped-defs',
    -- }
    -- local groups = { 'file', 'lnum', 'col', 'severity', 'message', 'code' }
    -- local severities = {
    --   error = vim.diagnostic.severity.ERROR,
    --   warning = vim.diagnostic.severity.WARN,
    --   note = vim.diagnostic.severity.HINT,
    -- }
    -- local pat = '([^:]+):(%d+):(%d+): (%a+): (.*)  %[([%a-]+)'
    -- mypy.parser = require('lint.parser').from_pattern(pat, groups, severities, { ['source'] = 'mypy' }, { end_col_offset = 0 })
    --
    -- lint.linters_by_ft = {
    --   python = { 'mypy' },
    -- }
