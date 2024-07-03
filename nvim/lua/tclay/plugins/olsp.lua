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

local on_attach = function(_, bufnr)
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
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

-- basic server configs where the lspconfig defaults are sensible
local servers = {
  marksman = {},
  jsonls = {},
  vimls = {},
  yamlls = {},
  html = { filetypes = { 'html', 'twig', 'hbs' } },
  cssls = {},
  svelte = {},
  dockerls = {},
  docker_compose_language_service = {},
  lua_ls = require 'servers.lua_ls',
  pyright = require 'servers.pyright',
  tsserver = require 'servers.tsserver',
  powershell_es = require 'servers.powershell_es',
}

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- return {
--   {
--     'neovim/nvim-lspconfig',
--     dependencies = {
--       { 'williamboman/mason.nvim', config = true }, -- Optional
--       { 'williamboman/mason-lspconfig.nvim' }, -- Optional
--       { 'hrsh7th/cmp-buffer' },
--       { 'folke/neodev.nvim' },
--       { 'hrsh7th/nvim-cmp' },
--       -- Snippet Engine & its associated nvim-cmp source
--       { 'L3MON4D3/LuaSnip' },
--       { 'saadparwaiz1/cmp_luasnip' },
--
--       { 'rafamadriz/friendly-snippets' },
--
--       -- Adds LSP completion capabilities
--       { 'hrsh7th/cmp-nvim-lsp' }, -- Required
--       { 'hrsh7th/vim-vsnip' },
--       { 'hrsh7th/vim-vsnip-integ' },
--     }, -- Required
--   },
-- }

vim.api.nvim_create_user_command('JdtStart', function(opts)
  vim.cmd.luafile(vim.fn.stdpath 'config' .. '/after/ftplugin/java.lua')
end, { nargs = '?' })

return {
  {
    'williamboman/mason-lspconfig.nvim', -- Optional
    config = function()
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
    end,
  },
}
