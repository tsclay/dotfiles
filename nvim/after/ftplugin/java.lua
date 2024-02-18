local system = vim.loop.os_uname().sysname
local home
local workspace_folder
local bundles
local JDK_PATH
local JAR
local JDT_CONFIG

local jdtls = require 'jdtls'

-- File types that signify a Java project's root directory. This will be
-- used by eclipse to determine what constitutes a workspace
local root_markers = { 'gradlew', 'mvnw', 'pom.xml', '.git', 'build.gradle' }
local root_dir = jdtls.setup.find_root(root_markers)

-- eclipse.jdt.ls stores project specific data within a folder. If you are working
-- with multiple different projects, each project must use a dedicated data directory.
-- This variable is used to configure eclipse to use the directory name of the
-- current project found using the root_marker as the folder for project specific data.
if system == 'Windows_NT' then
  home = os.getenv 'UserProfile'
  workspace_folder = home .. 'AppData/Local/Eclipse/' .. vim.fn.fnamemodify(root_dir, ':p:h:t')
  bundles = {
    vim.fn.glob(home .. '/AppData/Local/nvim-data/com.microsoft.java.debug.plugin-*.jar'),
    vim.fn.glob(home .. '/AppData/Local/nvim-data/com.microsoft.jdtls.ext.core-*.jar')
  }
  JDK_PATH = 'C:/Program Files/'
  JAR = vim.fn.glob(home .. '/AppData/Local/nvim-data/eclipse.jdt.ls/plugins/org.eclipse.equinox.launcher_*.jar')
  JDT_CONFIG = home .. '/AppData/Local/nvim-data/eclipse.jdt.ls/config_win'
else
  home = os.getenv 'HOME'
  workspace_folder = home .. '/.eclipse/' .. vim.fn.fnamemodify(root_dir, ':p:h:t')
  bundles = {
    vim.fn.glob(home .. '/.local/share/nvim/com.microsoft.java.debug.plugin-*.jar'),
    vim.fn.glob(home .. '/.local/share/nvim/com.microsoft.jdtls.ext.core-*.jar'),
    vim.fn.glob(home .. '/.local/share/nvim/pde/*.jar')
  }
  JDK_PATH = '/usr/lib/jvm/openjdk/21.0.1'
  JAR = vim.fn.glob(home .. '/.local/share/nvim/eclipse.jdt.ls/plugins/org.eclipse.equinox.launcher_*.jar')
  JDT_CONFIG = home .. '/.local/share/nvim/eclipse.jdt.ls/config_linux'
end

-- if on MacOS, using homebrew to install JDK
if system == 'Darwin' then
  -- JDK_PATH = '/usr/local/Cellar/openjdk/21.0.1/bin/java'
  JAR = vim.fn.glob(home .. '/.local/share/nvim/eclipse.jdt.ls/plugins/org.eclipse.equinox.launcher_*.jar')
  JDK_PATH = '/Library/Java/JavaVirtualMachines/jdk-17.0.2.jdk/Contents/Home/bin/java'
  JDT_CONFIG = home .. '/.local/share/nvim/eclipse.jdt.ls/config_mac'
end

-- Helper function for creating keymaps
local function nnoremap(rhs, lhs, bufopts, desc)
  bufopts.desc = desc
  vim.keymap.set('n', rhs, lhs, bufopts)
end

-- The on_attach function is used to set key maps after the language server
-- attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Regular Neovim LSP client keymappings
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  nnoremap('gD', vim.lsp.buf.declaration, bufopts, 'Go to declaration')
  nnoremap('gd', vim.lsp.buf.definition, bufopts, 'Go to definition')
  nnoremap('gi', vim.lsp.buf.implementation, bufopts, 'Go to implementation')
  nnoremap('K', vim.lsp.buf.hover, bufopts, 'Hover text')
  nnoremap('<C-k>', vim.lsp.buf.signature_help, bufopts, 'Show signature')
  nnoremap('<space>wa', vim.lsp.buf.add_workspace_folder, bufopts, 'Add workspace folder')
  nnoremap('<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts, 'Remove workspace folder')
  nnoremap('<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts, 'List workspace folders')
  nnoremap('<space>D', vim.lsp.buf.type_definition, bufopts, 'Go to type definition')
  nnoremap('<space>rn', vim.lsp.buf.rename, bufopts, 'Rename')
  nnoremap('<space>ca', vim.lsp.buf.code_action, bufopts, 'Code actions')
  vim.keymap.set(
    'v',
    '<space>ca',
    '<ESC><CMD>lua vim.lsp.buf.range_code_action()<CR>',
    { noremap = true, silent = true, buffer = bufnr, desc = 'Code actions' }
  )
  nnoremap('<space>f', function()
    vim.lsp.buf.format { async = true }
  end, bufopts, 'Format file')
  nnoremap('<leader>pcs', require('telescope.builtin').lsp_dynamic_workspace_symbols, bufopts, 'Search for workspace symbols')

  -- Java extensions provided by jdtls
  nnoremap('<C-o>', jdtls.organize_imports, bufopts, 'Organize imports')
  nnoremap('<space>ev', jdtls.extract_variable, bufopts, 'Extract variable')
  nnoremap('<space>ec', jdtls.extract_constant, bufopts, 'Extract constant')
  vim.keymap.set(
    'v',
    '<space>em',
    [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]],
    { noremap = true, silent = true, buffer = bufnr, desc = 'Extract method' }
  )
  require('jdtls').setup_dap { hotcodereplace = 'auto' }
  jdtls.setup.add_commands()
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

local config = {
  flags = {
    debounce_text_changes = 80,
  },
  capabilities = capabilities,
  on_attach = on_attach, -- We pass our on_attach keybindings to the configuration map
  root_dir = root_dir, -- Set the root directory to our found root_marker
  -- Here you can configure eclipse.jdt.ls specific settings
  -- These are defined by the eclipse.jdt.ls project and will be passed to eclipse when starting.
  -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
  -- for a list of options
  init_options = {
    bundles = bundles,
  },
  settings = {
    java = {
      format = {
        settings = {
          -- Use Google Java style guidelines for formatting
          -- To use, make sure to download the file from https://github.com/google/styleguide/blob/gh-pages/eclipse-java-google-style.xml
          -- and place it in the ~/.local/share/eclipse directory
          url = '',
          profile = '',
        },
      },
      signatureHelp = { enabled = true },
      contentProvider = { preferred = 'fernflower' }, -- Use fernflower to decompile library code
      -- Specify any completion options
      completion = {
        favoriteStaticMembers = {
          'org.hamcrest.MatcherAssert.assertThat',
          'org.hamcrest.Matchers.*',
          'org.hamcrest.CoreMatchers.*',
          'org.junit.jupiter.api.Assertions.*',
          'java.util.Objects.requireNonNull',
          'java.util.Objects.requireNonNullElse',
          'org.mockito.Mockito.*',
        },
        filteredTypes = {
          'com.sun.*',
          'io.micrometer.shaded.*',
          'java.awt.*',
          'jdk.*',
          'sun.*',
        },
      },
      -- Specify any options for organizing imports
      sources = {
        organizeImports = {
          starThreshold = 9999,
          staticStarThreshold = 9999,
        },
      },
      -- How code generation should act
      codeGeneration = {
        toString = {
          template = '${object.className}{${member.name()}=${member.value}, ${otherMembers}}',
        },
        hashCodeEquals = {
          useJava7Objects = true,
        },
        useBlocks = true,
      },
      -- If you are developing in projects with different Java versions, you need
      -- to tell eclipse.jdt.ls to use the location of the JDK for your Java version
      -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
      -- And search for `interface RuntimeOption`
      -- The `name` is NOT arbitrary, but must match one of the elements from `enum ExecutionEnvironment` in the link above
      configuration = {
        runtimes = {
          -- {
          --   name = "JavaSE-11",
          --   path = "C:/Program Files/Amazon Corretto/jdk11.0.18_10",
          -- },
          {
            name = "JavaSE-11",
            path = "/usr/local/opt/openjdk@11/libexec/openjdk.jdk/Contents/Home",
          },
          {
            name = 'JavaSE-21',
            path = '/usr/local/Cellar/openjdk/21.0.1',
          },
        },
      },
    },
  },
  -- cmd is the command that starts the language server. Whatever is placed
  -- here is what is passed to the command line to execute jdtls.
  -- Note that eclipse.jdt.ls must be started with a Java version of 17 or higher
  -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
  -- for the full list of options
  cmd = {
    JDK_PATH,
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xmx4g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens',
    'java.base/java.util=ALL-UNNAMED',
    '--add-opens',
    'java.base/java.lang=ALL-UNNAMED',
    -- If you use lombok, download the lombok jar and place it in ~/.local/share/eclipse

    -- The jar file is located where jdtls was installed. This will need to be updated
    -- to the location where you installed jdtls
    '-jar',
    JAR,

    -- The configuration for jdtls is also placed where jdtls was installed. This will
    -- need to be updated depending on your environment
    '-configuration',
    JDT_CONFIG,

    -- Use the workspace_folder defined above to store data for this project
    '-data',
    workspace_folder,
  },
}

local function dump(o)
  if type(o) == 'table' then
    local s = '{ '
    for k, v in pairs(o) do
      if type(k) ~= 'number' then
        k = '"' .. k .. '"'
      end
      s = s .. '[' .. k .. '] = ' .. dump(v) .. ','
    end
    print(s .. '} ')
    return s .. '} '
  else
    print(o)
    return tostring(o)
  end
end

-- require('dap.ext.vscode').load_launchjs()

-- nvim-dap
-- nnoremap("<leader>bb", "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "Set breakpoint")
-- nnoremap("<leader>bc", "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>", "Set conditional breakpoint")
-- nnoremap("<leader>bl", "<cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<cr>", "Set log point")
-- nnoremap('<leader>br', "<cmd>lua require'dap'.clear_breakpoints()<cr>", "Clear breakpoints")
-- nnoremap('<leader>ba', '<cmd>Telescope dap list_breakpoints<cr>', "List breakpoints")

-- nnoremap("<leader>dc", "<cmd>lua require'dap'.continue()<cr>", "Continue")
-- nnoremap("<leader>dj", "<cmd>lua require'dap'.step_over()<cr>", "Step over")
-- nnoremap("<leader>dk", "<cmd>lua require'dap'.step_into()<cr>", "Step into")
-- nnoremap("<leader>do", "<cmd>lua require'dap'.step_out()<cr>", "Step out")
-- nnoremap('<leader>dd', "<cmd>lua require'dap'.disconnect()<cr>", "Disconnect")
-- nnoremap('<leader>dt', "<cmd>lua require'dap'.terminate()<cr>", "Terminate")
-- nnoremap("<leader>dr", "<cmd>lua require'dap'.repl.toggle()<cr>", "Open REPL")
-- nnoremap("<leader>dl", "<cmd>lua require'dap'.run_last()<cr>", "Run last")
-- nnoremap('<leader>di', function() require"dap.ui.widgets".hover() end, "Variables")
-- nnoremap('<leader>d?', function() local widgets=require"dap.ui.widgets";widgets.centered_float(widgets.scopes) end, "Scopes")
-- nnoremap('<leader>df', '<cmd>Telescope dap frames<cr>', "List frames")
-- nnoremap('<leader>dh', '<cmd>Telescope dap commands<cr>', "List commands")

local cmp = require 'cmp'
local lspkind = require 'lspkind'
cmp.setup {
  sources = {
    { name = 'nvim_lsp' },
    { name = 'nvim_lsp_signature_help' },
    { name = 'vsnip' },
  },
  snippet = {
    expand = function(args)
      vim.fn['vsnip#anonymous'](args.body) -- because we are using the vsnip cmp plugin
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    -- ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  formatting = {
    fields = { "kind", "abbr", "menu" },
    expandable_indicator = true,
    format = lspkind.cmp_format {
      mode = 'symbol_text',
      maxwidth = 50,
      ellipsis_char = '...',
      before = function(_, vim_item)
        return vim_item
      end,
    },
  },
}

-- Finally, start jdtls. This will run the language server using the configuration we specified,
-- setup the keymappings, and attach the LSP client to the current buffer
jdtls.start_or_attach(config)
