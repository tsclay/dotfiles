-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- NOTE: Here is where you install your plugins.
--  You can configure plugins using the `config` key.
--
--  You can also configure plugins after the setup call,
--    as they will be available in your neovim runtime.
-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!

require('lazy').setup({
  -- NOTE: First, some plugins that don't require any configuration
  {
    'Joakker/lua-json5',
    build = function()
      vim.fn.system './install.sh'
    end,
  },
  {
    'stevearc/oil.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  },
  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',
  { 'tpope/vim-dotenv', lazy = false },
  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- NOTE: This is where your plugins related to LSP can be installed.
  --  The configuration is done below. Search for lspconfig to find it below.
  'mfussenegger/nvim-lint',
  'mfussenegger/nvim-jdtls',
  {
    'mfussenegger/nvim-dap-python',
    build = function()
      local home
      local venv_py
      local py_exe
      -- presumes python is on the path
      if vim.fn.has 'win32' == 1 then
        home = os.getenv 'UserProfile'
        py_exe = vim.fn.exepath 'python.exe'
        venv_py = home .. '/.virtualenvs/debugpy/Scripts/python.exe'
      else
        home = os.getenv 'HOME'
        py_exe = vim.fn.exepath 'python3'
        venv_py = home .. '/.virtualenvs/debugpy/bin/python'
      end
      if vim.fn.isdirectory(home .. '/.virtualenvs') == 0 then
        vim.fn.mkdir(home .. '/.virtualenvs')
      end
      if vim.fn.isdirectory(home .. '/.virtualenvs/debugpy') == 0 then
        -- TODO: Have to find global python exe depending on OS
        vim.fn.system { py_exe, '-m', 'venv', home .. '/.virtualenvs/debugpy' }
        vim.fn.system { venv_py, '-m', 'pip', 'install', 'debugpy' }
      else
        vim.fn.system { venv_py, '-m', 'pip', 'install', 'debugpy', '-U' }
      end
    end,
    config = function()
      local debugpy_path
      if vim.fn.has 'win32' == 1 then
        debugpy_path = os.getenv 'UserProfile' .. '/.virtualenvs/debugpy/Scripts/python.exe'
      else
        debugpy_path = os.getenv 'HOME' .. '/.virtualenvs/debugpy/bin/python'
      end
      require('dap-python').setup(debugpy_path)
    end,
  },
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v2.x',
    dependencies = {
      -- LSP Support
      {
        'onsails/lspkind.nvim',
      },
      { 'mhartington/formatter.nvim' },
      { 'neovim/nvim-lspconfig' }, -- Required
      { 'williamboman/mason.nvim', config = true }, -- Optional
      { 'williamboman/mason-lspconfig.nvim' }, -- Optional
      { 'j-hui/fidget.nvim', tag = 'legacy', opts = { window = { blend = 0 } } },
      'folke/neodev.nvim',
      {
        -- Autocompletion
        'hrsh7th/nvim-cmp',
        dependencies = {
          -- Snippet Engine & its associated nvim-cmp source
          'L3MON4D3/LuaSnip',
          'saadparwaiz1/cmp_luasnip',

          -- Adds a number of user-friendly snippets
          'rafamadriz/friendly-snippets',
        },
      }, -- Required
      -- Adds LSP completion capabilities
      { 'hrsh7th/cmp-nvim-lsp' }, -- Required
      { 'hrsh7th/vim-vsnip', dependencies = {
        'hrsh7th/vim-vsnip-integ',
      } },
    },
  },
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
  },
  {
    'microsoft/vscode-js-debug',
    build = 'npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out',
  },
  {
    'ray-x/go.nvim',
    dependencies = { -- optional packages
      'ray-x/guihua.lua',
      'neovim/nvim-lspconfig',
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('go').setup()
    end,
    event = { 'CmdlineEnter' },
    ft = { 'go', 'gomod' },
    build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
  },
  {
    'RRethy/vim-illuminate',
    -- cmd = "IlluminateToggle",
    -- keys = {
    --   -- { "<leader>ti", require("illuminate").toggle(), "[T]oggle [I]lluminate" }
    --   { "<leader>ti", "<cmd>IlluminateToggle<CR>", "[T]oggle [I]lluminate" },
    -- },
    opts = {
      -- filetypes_denylist = {
      --   "dirvish",
      --   "fugitive",
      --   "md",
      --   "org",
      --   "norg",
      --   "NvimTree",
      -- },
    },
    config = function(opts)
      require('illuminate').configure {
        filetypes_denylist = {
          'fugitive',
          'org',
          'norg',
          'NvimTree',
        },
      }

      vim.keymap.set('n', '<leader>ti', '<cmd>IlluminateToggle<CR>', { desc = '[T]oggle [I]lluminate' })
      vim.keymap.set('n', '<leader>tf', require('illuminate').toggle_freeze_buf, { desc = '[F]reeze Illuminate' })
    end,
  },
  {
    -- have to lazy load to avoid race condition with dotenv
    'tpope/vim-dadbod',
    opt = true,
    dependencies = {
      'kristijanhusak/vim-dadbod-ui',
      'kristijanhusak/vim-dadbod-completion',
    },
    init = function()
      vim.g.db_ui_save_location = vim.fn.stdpath 'config' .. require('plenary.path').path.sep .. 'db_ui'
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_dotenv_variable_prefix = 'DATABASE_URL_'
      vim.g.db_ui_execute_on_save = 0

      -- Database
      vim.keymap.set('n', 'Du', '<Cmd>DBUIToggle<Cr>', { desc = 'Toggle UI' })
      vim.keymap.set('n', 'Df', '<Cmd>DBUIFindBuffer<Cr>', { desc = 'Find buffer' })
      vim.keymap.set('n', 'Dr', '<Cmd>DBUIRenameBuffer<Cr>', { desc = 'Rename buffer' })
      vim.keymap.set('n', 'Dq', '<Cmd>DBUILastQueryInfo<Cr>', { desc = 'Last query info' })
      vim.keymap.set('n', 'Dh', '<Cmd>DBUIHideNotifications<Cr>', { desc = 'Hide notifications' })
    end,
    config = function()
      require('tclay.config.dadbod').setup()
    end,
    cmd = { 'DBUIToggle', 'DBUI', 'DBUIAddConnection', 'DBUIFindBuffer', 'DBUIRenameBuffer', 'DBUILastQueryInfo', 'DBUIHideNotifications' },
  },
  {
    'hrsh7th/cmp-buffer',
  },
  { 'akinsho/bufferline.nvim', version = '*', dependencies = 'nvim-tree/nvim-web-devicons' },
  {
    'windwp/nvim-autopairs',
    -- Optional dependency
    dependencies = { 'hrsh7th/nvim-cmp' },
    config = function()
      require('nvim-autopairs').setup {}
      -- If you want to automatically add `(` after selecting a function or method
      local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
      local cmp = require 'cmp'
      cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
    end,
  },
  "windwp/nvim-ts-autotag",
  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim', opts = {} },
  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        vim.keymap.set('n', '<leader>gp', require('gitsigns').prev_hunk, { buffer = bufnr, desc = '[G]o to [P]revious Hunk' })
        vim.keymap.set('n', '<leader>gn', require('gitsigns').next_hunk, { buffer = bufnr, desc = '[G]o to [N]ext Hunk' })
        vim.keymap.set('n', '<leader>ph', require('gitsigns').preview_hunk, { buffer = bufnr, desc = '[P]review [H]unk' })
      end,
    },
  },
  {
    -- transparency set manually then cached on subsequent openings of nvim
    'xiyaowong/transparent.nvim',
    lazy = false,
  },
  {
    -- Theme inspired by Atom
    'navarasu/onedark.nvim',
    priority = 0,
    -- lazy = true,
  },
  {
    'talha-akram/noctis.nvim',
    -- lazy = true,
    -- init = function()
    --   vim.cmd 'colorscheme noctis_azureus'
    --   -- needed for transparent.nvim so that colorscheme is correctly set on toggles
    --   vim.g.colors_name = 'noctis_azureus'
    -- end,
  },
  {
    'lalitmee/cobalt2.nvim',
    event = { 'ColorSchemePre' }, -- if you want to lazy load
    dependencies = { lazy = true, 'tjdevries/colorbuddy.nvim' },
    -- init = function()
    -- require('colorbuddy').colorscheme 'cobalt2'
    -- end,
  },
  -- {
  --   'norcalli/nvim-colorizer.lua',
  --   config = function()
  --     require('colorizer').setup()
  --   end,
  -- },
  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
  },
  {
    'theprimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
  },
  {
    'mbbill/undotree',
  },
  { 'lukas-reineke/indent-blankline.nvim', main = 'ibl', opts = {} },

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },
  'JoosepAlviste/nvim-ts-context-commentstring',
  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    ft = { 'markdown' },
    build = function()
      vim.fn['mkdp#util#install']()
    end,
  },
  -- Fuzzy Finder (files, lsp, etc)
  { 'nvim-telescope/telescope.nvim', branch = '0.1.x', dependencies = { 'nvim-lua/plenary.nvim' } },

  -- Fuzzy Finder Algorithm which requires local dependencies to be built.
  -- Only load if `make` is available. Make sure you have the system
  -- requirements installed.
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    -- NOTE: If you are having trouble with this installation,
    --       refer to the README for telescope-fzf-native for more instructions.
    build = 'make',
    cond = function()
      return vim.fn.executable 'make' == 1
    end,
  },

  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    run = ':TSUpdate',
  },
  {
    'nvim-treesitter/playground',
  },
  {
    'nvim-tree/nvim-tree.lua',
    version = '*',
    lazy = false,
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    -- config = function()
    --   require('nvim-tree').setup {}
    -- end,
  },
  {
    'folke/trouble.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      auto_preview = false
    },
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  },
  -- NOTE: Next Step on Your Neovim Journey: Add/Configure additional "plugins" for kickstart
  --       These are some example plugins that I've included in the kickstart repository.
  --       Uncomment any of the lines below to enable them.
  -- require 'kickstart.plugins.autoformat',
  -- require 'kickstart.plugins.debug',

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    You can use this folder to prevent any conflicts with this init.lua if you're interested in keeping
  --    up-to-date with whatever is in the kickstart repo.
  --    Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  --
  --    For additional information see: https://github.com/folke/lazy.nvim#-structuring-your-plugins
  -- { import = 'custom.plugins' },
}, {})
