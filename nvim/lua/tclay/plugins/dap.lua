return {
  {
    -- NOTE: Yes, you can install new plugins here!
    'mfussenegger/nvim-dap',
    -- NOTE: And you can specify dependencies as well
    dependencies = {
      -- Creates a beautiful debugger UI
      'rcarriga/nvim-dap-ui',

      -- Installs the debug adapters for you
      'williamboman/mason.nvim',
      'jay-babu/mason-nvim-dap.nvim',

      -- Add your own debuggers here
      -- 'leoluz/nvim-dap-go',
      -- {
      --   'mxsdev/nvim-dap-vscode-js',
      --   opts = {
      --     debugger_path = vim.fn.stdpath 'data' .. '/lazy/vscode-js-debug',
      --     adapters = { 'pwa-node', 'pwa-chrome', 'node-terminal' },
      --   },
      -- },
      -- 'mxsdev/nvim-dap-vscode-js',
    },
    config = function()
      local dap = require 'dap'
      dap.set_log_level 'TRACE'

      -- Basic debugging keymaps, feel free to change to your liking!
      vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug: Start/Continue' })
      vim.keymap.set('n', '<F1>', dap.step_into, { desc = 'Debug: Step Into' })
      vim.keymap.set('n', '<F2>', dap.step_over, { desc = 'Debug: Step Over' })
      vim.keymap.set('n', '<F3>', dap.step_out, { desc = 'Debug: Step Out' })
      vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
      vim.keymap.set('n', '<leader>B', function()
        dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      end, { desc = 'Debug: Set Breakpoint' })

      dap.adapters.nlua = function(callback, config)
        callback { type = 'server', host = config.host, port = config.port }
      end

      dap.adapters['pwa-node'] = {
        type = 'server',
        host = 'localhost',
        port = '${port}',
        executable = {
          command = 'js-debug-adapter',
          args = { '${port}' },
          -- command = "node",
          -- 💀 Make sure to update this path to point to your installation
          -- args = {vim.fn.expand('~/js-debug/src/dapDebugServer.js'), "${port}"},
        },
      }

      dap.adapters['node'] = {
        type = 'server',
        host = 'localhost',
        port = '${port}',
        executable = {
          command = 'js-debug-adapter',
          args = { '${port}' },
          -- command = "node",
          -- 💀 Make sure to update this path to point to your installation
          -- args = {vim.fn.stdpath('data') .. '/lazy/vscode-js-debug/src/dapDebugServer.js', "${port}"},
          -- args = {vim.fn.expand('~/js-debug/src/dapDebugServer.js'), "${port}"},
        },
      }

      for _, language in ipairs { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' } do
        dap.configurations[language] = {
          -- {
          --   -- ..., -- see below
          --   name = 'next/svelte/whatever',
          --   type = 'node-terminal',
          --   request = 'launch',
          --   command = 'npm run dev',
          --   cwd = '${workspaceFolder}',
          -- },
          -- {
          --   type = 'node',
          --   request = 'attach',
          --   name = 'Attach to existing debugger',
          --   port = 9229,
          --   skipFiles = { '<node_internals>/**' },
          -- },

          -- Next.js
          {
            type = 'pwa-node',
            request = 'launch',
            name = 'Launch Next (Debug)',
            cwd = '${workspaceFolder}',
            runtimeExecutable = 'npx',
            runtimeArgs = { 'next', 'dev' },
          },
          -- Node script
          {
            type = 'pwa-node',
            request = 'launch',
            name = 'Launch current file',
            program = '${file}',
            cwd = '${workspaceFolder}',
          },
        }
      end

      -- Svelte/Sveltekit
      dap.configurations.svelte = {
        {
          type = 'pwa-node',
          request = 'launch',
          name = 'Launch Sveltekit (Debug)',
          cwd = '${workspaceFolder}',
          runtimeExecutable = 'npx',
          runtimeArgs = { 'vite', 'dev' },
        },
      }

      -- Lua
      dap.configurations.lua = {
        {
          type = 'nlua',
          request = 'attach',
          name = 'Attach to running Neovim instance',
          host = function()
            local value = vim.fn.input 'Host [127.0.0.1]: '
            if value ~= '' then
              return value
            end
            return '127.0.0.1'
          end,
          port = function()
            local val = tonumber(vim.fn.input('Port: ', '54321'))
            assert(val, 'Please provide a port number')
            return val
          end,
        },
      }

      require('dap.ext.vscode').load_launchjs(nil, { node = { 'javascript', 'javascriptreact', 'typescriptreact', 'typescript' } })
    end,
  },
}

-- Install golang specific config
-- require('dap-go').setup()
-- require('dap-vscode-js').setup {
--   -- node_path = 'node', -- Path of node executable. Defaults to $NODE_PATH, and then "node"
--   debugger_path = vim.fn.stdpath('data') .. '/lazy/vscode-js-debug',
--   -- debugger_cmd = { "js-debug-adapter" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
--   adapters = { 'node', 'chrome', 'msedge', 'node-terminal', 'extensionHost' }, -- which adapters to register in nvim-dap
--   log_file_path = vim.fn.expand "~/.cache/dap_vscode_js.log", -- Path for file logging
--   log_file_level = 2-- Logging level for output to file. Set to false to disable file logging.
--   -- log_console_level = vim.log.levels.ERROR -- Logging level for output to console. Set to false to disable console output.
-- }
-- require('dap.ext.vscode').load_launchjs()
