-- -- [[ Configure LSP ]]
-- --  This function gets run when an LSP connects to a particular buffer.
-- local augroup_format = vim.api.nvim_create_augroup('Format', { clear = true })
-- local enable_format_on_save = function(_, bufnr)
--   vim.api.nvim_clear_autocmds { group = augroup_format, buffer = bufnr }
--   vim.api.nvim_create_autocmd('BufWritePre', {
--     group = augroup_format,
--     buffer = bufnr,
--     callback = function()
--       local formatter = require 'formatter.filetypes'
--       if formatter[vim.bo.filetype] ~= nil then
--         vim.cmd [[Format]]
--       else
--         vim.lsp.buf.format { bufnr = bufnr }
--       end
--     end,
--   })
-- end
local function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

local on_attach = function(_, bufnr)
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')
end

local function get_python_path(workspace)
  -- Use activated virtualenv.
  -- print('the workspace: ' .. workspace)
  local path = require('lspconfig/util').path
  if vim.env.VIRTUAL_ENV then
    -- print 'Using virtualenv that was sourced'
    return path.join(vim.env.VIRTUAL_ENV, 'bin', 'python')
  end

  -- Find and use virtualenv in workspace directory.
  for _, pattern in ipairs { '*', '.*' } do
    local match = vim.fn.glob(path.join(workspace, pattern, 'pyvenv.cfg'))
    -- print(match)
    if match ~= '' then
      -- print('the return value: ' .. path.join(path.dirname(match), 'bin', 'python'))
      return path.join(path.dirname(match), 'bin', 'python')
    end
  end
  -- Fallback to system Python.
  return vim.fn.exepath 'python3' or vim.fn.exepath 'python' or 'python'
end

local function get_root(...)
  -- print(...)
  local util = require 'lspconfig/util'
  local primary = util.root_pattern(...)
  -- print("the primary is ", primary(vim.fn.getcwd()))
  -- local fallback = vim.loop.cwd()
  return primary and primary(vim.fn.getcwd()) or ''
end

local servers = {
  pyright = {
    cmd = {
      'pyright-langserver',
      '--stdio',
    },
    settings = {
      python = {
        pythonPath = get_python_path(get_root('pyvenv.cfg', 'venv', '.git', 'requirements.txt')),
      },
    },
  },
  jsonls = {},
  tsserver = {
    filetypes = { 'javascript', 'javascriptreact', 'javascript.jsx', 'typescript', 'typescriptreact', 'typescript.tsx' },
    cmd = { 'typescript-language-server', '--stdio' },
    -- root_dir = function(fname)
    -- local primary = require('lspconfig.util').root_pattern('tsconfig.json', '.git')
    -- print(primary and primary())
    -- local fallback = vim.loop.cwd()
    -- print(fallback)
    -- return primary and primary() or fallback
    -- end,
  },
  html = { filetypes = { 'html', 'twig', 'hbs' } },
  cssls = {},

  -- lua_ls = {
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
  --   settings = {
  --     Lua = {
  --       telemetry = false
  --     }
  --   }
  --   -- Lua = {
  --   --   diagnostics = {
  --   --     globals = { 'vim' },
  --   --   },
  --   --   workspace = {
  --   --     checkThirdParty = false,
  --   --     library = vim.api.nvim_get_runtime_file('', true),
  --   --   },
  --   --   telemetry = { enable = false },
  --   -- },
  -- },
}
-- local attach_overrides = {
--   lua_ls = {
--     on_attach = function(client, bufnr)
--       on_attach(client, bufnr)
--       enable_format_on_save(client, bufnr)
--     end,
--   },
-- }
-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      on_init = (servers[server_name] or {}).on_init,
      capabilities = capabilities,
      on_attach = on_attach,
      settings = (servers[server_name] or {}).settings,
      filetypes = (servers[server_name] or {}).filetypes,
      cmd = (servers[server_name] or {}).cmd,
      root_dir = (servers[server_name] or {}).root_dir,
    }
  end,
}
-- vim.diagnostic.config {
-- virtual_text = false,
-- }
vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  underline = true,
  update_in_insert = false,
  virtual_text = { spacing = 4, prefix = '\u{ea71}' },
  severity_sort = true,
})

-- Diagnostic symbols in the sign column (gutter)
local signs = { Error = ' ', Warn = ' ', Hint = ' ', Info = ' ' }
for type, icon in pairs(signs) do
  local hl = 'DiagnosticSign' .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
end

vim.diagnostic.config {
  virtual_text = {
    prefix = '●',
  },
  update_in_insert = true,
  float = {
    source = 'always', -- Or "if_many"
  },
}
