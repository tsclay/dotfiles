return {
  filetypes = { 'javascript', 'javascriptreact', 'javascript.jsx', 'typescript', 'typescriptreact', 'typescript.tsx' },
  cmd = { 'typescript-language-server', '--stdio' },
  -- root_dir = function(fname)
  -- local primary = require('lspconfig.util').root_pattern('tsconfig.json', '.git')
  -- print(primary and primary())
  -- local fallback = vim.loop.cwd()
  -- print(fallback)
  -- return primary and primary() or fallback
  -- end,
}
