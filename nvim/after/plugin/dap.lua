local dap = require 'dap'
local dapui = require 'dapui'

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

-- Dap UI setup
-- For more information, see |:help nvim-dap-ui|
dapui.setup {
  -- Set icons to characters that are more likely to work in every terminal.
  --    Feel free to remove or use ones that you like more! :)
  --    Don't feel like these are good choices.
  icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
  controls = {
    icons = {
      pause = '⏸',
      play = '▶',
      step_into = '⏎',
      step_over = '⏭',
      step_out = '⏮',
      step_back = 'b',
      run_last = '▶▶',
      terminate = '⏹',
      disconnect = '⏏',
    },
  },
}

vim.fn.sign_define('DapBreakpoint', { text = '🛑', texthl = '', linehl = '', numhl = '' })
-- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
vim.keymap.set('n', '<F7>', dapui.toggle, { desc = 'Debug: See last session result.' })

dap.listeners.after.event_initialized['dapui_config'] = dapui.open
dap.listeners.before.event_terminated['dapui_config'] = dapui.close
dap.listeners.before.event_exited['dapui_config'] = dapui.close

dap.adapters.nlua = function(callback, config)
  callback { type = 'server', host = config.host, port = config.port }
end
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
-- require('dap.ext.vscode').load_launchjs()
