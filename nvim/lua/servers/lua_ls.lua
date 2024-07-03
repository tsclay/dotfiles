return {
  --   on_init = function(client)
  --     local path = client.workspace_folders[1].name
  --     if not vim.loop.fs_stat(path .. '/.luarc.json') and not vim.loop.fs_stat(path .. '/.luarc.jsonc') then
  --       print("shoud do things")
  --       client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
  --         Lua = {
  --           diagnostics = {
  --             globals = { 'vim' },
  --           },
  --           runtime = {
  --             -- Tell the language server which version of Lua you're using
  --             -- (most likely LuaJIT in the case of Neovim)
  --             version = 'LuaJIT',
  --           },
  --           -- Make the server aware of Neovim runtime files
  --           workspace = {
  --             checkThirdParty = false,
  --             library = {
  --               vim.env.VIMRUNTIME,
  --               -- "${3rd}/luv/library"
  --               -- "${3rd}/busted/library",
  --             },
  --             -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
  --             -- library = vim.api.nvim_get_runtime_file("", true)
  --           },
  --         },
  --       })
  --       print(dump(client.config.settings))
  --       client.notify('workspace/didChangeConfiguration', { settings = client.config.settings })
  --     end
  --     return true
  --   end,
  settings = {
    -- Lua = {
    --   telemetry = false
    -- }
    -- }
    Lua = {
      diagnostics = {
        globals = { 'vim' },
      },
      workspace = {
        checkThirdParty = false,
        library = vim.api.nvim_get_runtime_file('', true),
      },
      telemetry = { enable = false },
    },
  },
}
