-- Utilities for creating configurations
local util = require 'formatter.util'
local settings = {
  -- Formatter configurations for filetype "lua" go here
  -- and will be executed in order
  lua = {
    -- "formatter.filetypes.lua" defines default configurations for the
    -- "lua" filetype
    require('formatter.filetypes.lua').stylua,

    -- You can also define your own configuration
    function()
      -- Supports conditional formatting
      if util.get_current_buffer_file_name() == 'special.lua' then
        return nil
      end

      -- Full specification of configurations is down below and in Vim help
      -- files
      return {
        exe = 'stylua',
        args = {
          '--search-parent-directories',
          '--stdin-filepath',
          util.escape_path(util.get_current_buffer_file_path()),
          '--',
          '-',
        },
        stdin = true,
      }
    end,
  },
  javascript = {
    -- prettierd
    function()
      return {
        exe = 'prettierd',
        args = { vim.api.nvim_buf_get_name(0) },
        stdin = true,
      }
    end,
  },
  yaml = {
    -- prettierd
    function()
      return {
        exe = 'prettierd',
        args = { vim.api.nvim_buf_get_name(0) },
        stdin = true,
      }
    end,
  },
  javascriptreact = {
    -- prettierd
    function()
      return {
        exe = 'prettierd',
        args = { vim.api.nvim_buf_get_name(0) },
        stdin = true,
      }
    end,
  },
  typescript = {
    -- prettierd
    function()
      return {
        exe = 'prettierd',
        args = { vim.api.nvim_buf_get_name(0) },
        stdin = true,
      }
    end,
  },
  typescriptreact = {
    -- prettierd
    function()
      return {
        exe = 'prettierd',
        args = { vim.api.nvim_buf_get_name(0) },
        stdin = true,
      }
    end,
  },
  css = {
    function()
      return {
        exe = 'prettierd',
        args = { vim.api.nvim_buf_get_name(0) },
        stdin = true,
      }
    end,
  },
  html = {
    function()
      return {
        exe = 'prettierd',
        args = { vim.api.nvim_buf_get_name(0) },
        stdin = true,
      }
    end,
  },
  go = {
    require('formatter.filetypes.go').gofmt,
  },
  python = {
    require('formatter.filetypes.python').black,
  },
  -- Use the special "*" filetype for defining formatter configurations on
  -- any filetype
  ['*'] = {
    -- "formatter.filetypes.any" defines default configurations for any
    -- filetype
    require('formatter.filetypes.any').remove_trailing_whitespace,
  },
}
-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
require('formatter').setup {
  -- Enable or disable logging
  logging = true,
  -- Set the log level
  log_level = vim.log.levels.WARN,
  -- All formatter configurations are opt-in
  filetype = settings,
}
-- https://github.com/mhartington/formatter.nvim/issues/260#issuecomment-1646573031
vim.keymap.set('n', '<leader>f', function()
  if settings[vim.bo.filetype] ~= nil then
    vim.cmd [[Format]]
  else
    vim.lsp.buf.format()
  end
end, { desc = 'Format file' })
