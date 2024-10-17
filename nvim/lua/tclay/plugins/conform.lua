return {
  'stevearc/conform.nvim',
  opts = {},
  config = function()
    local conform = require 'conform'
    conform.setup {
      formatters_by_ft = {
        lua = { 'stylua' },
        -- Conform will run multiple formatters sequentially
        python = { 'black' },
        -- Conform will run the first available formatter
        javascript = { 'prettierd', 'prettier', stop_after_first = true },
      },
    }

    vim.keymap.set('n', '<leader>f', function()
      conform.format()
    end, { silent = true, noremap = true }) --use formatter.nvim
  end,
}
