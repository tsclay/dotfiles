local system = vim.loop.os_uname().sysname

vim.opt.guicursor = ''

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.env.PRETTIERD_DEFAULT_CONFIG = vim.fn.expand '~/.config/nvim/utils/linter-config/.prettierrc.json'
vim.opt.swapfile = false
vim.opt.backup = false

if system == 'Windows_NT' then
  vim.opt.undodir = os.getenv 'UserProfile' .. '/.vim/undodir'
else
  vim.opt.undodir = os.getenv 'HOME' .. '/.vim/undodir'
end

vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = 'yes'
vim.opt.isfname:append '@-@'

vim.opt.updatetime = 50

vim.opt.colorcolumn = '120'

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
--vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Don't want files showing as changed because of line endings
vim.api.nvim_create_autocmd('BufEnter', {
  callback = function()
    if vim.api.nvim_buf_get_option(0, 'modifiable') == true then
      vim.cmd [[set fileformat=unix]]
    end
  end,
})

local _border = 'single'

vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = _border,
})

vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = _border,
})

vim.diagnostic.config {
  float = { border = _border },
}

-- https://github.com/nvim-tree/nvim-tree.lua/wiki/Recipes#go-to-last-used-hidden-buffer-when-deleting-a-buffer
-- vim.api.nvim_create_autocmd("BufEnter", {
--   nested = true,
--   callback = function()
--     local api = require('nvim-tree.api')
--
--     -- Only 1 window with nvim-tree left: we probably closed a file buffer
--     if #vim.api.nvim_list_wins() == 1 and api.tree.is_tree_buf() then
--       -- Required to let the close event complete. An error is thrown without this.
--       vim.defer_fn(function()
--         -- close nvim-tree: will go to the last hidden buffer used before closing
--         api.tree.toggle({find_file = true, focus = true})
--         -- re-open nivm-tree
--         api.tree.toggle({find_file = true, focus = true})
--         -- nvim-tree is still the active window. Go to the previous window.
--         vim.cmd("wincmd p")
--       end, 0)
--     end
--   end
-- })
