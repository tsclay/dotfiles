--
-- This function has been generated from your
--   view.mappings.list
--   view.mappings.custom_only
--   remove_keymaps
--
-- You should add this function to your configuration and set on_attach = on_attach in the nvim-tree setup call.
--
-- Although care was taken to ensure correctness and completeness, your review is required.
--
-- Please check for the following issues in auto generated content:
--   "Mappings removed" is as you expect
--   "Mappings migrated" are correct
--
-- Please see https://github.com/nvim-tree/nvim-tree.lua/wiki/Migrating-To-on_attach for assistance in migrating.
--

local function my_on_attach(bufnr)
  local api = require 'nvim-tree.api'

  local function opts(desc)
    return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  local function edit_or_open()
    local node = api.tree.get_node_under_cursor()

    if node.nodes ~= nil then
      -- expand or collapse folder
      api.node.open.edit()
    else
      -- open file
      api.node.open.edit()
      -- Close the tree if file was opened
      api.tree.close()
    end
  end

  local function open_buf_as_tab()
    local node = api.tree.get_node_under_cursor()
    if node.nodes ~= nil then
      -- expand or collapse folder
      api.node.open.edit()
    else
      -- open file in new tab
      -- api.tree.focus()

      vim.cmd 'wincmd l'
      api.node.open.tab(node)
    end
  end
  -- open as vsplit on current node
  local function vsplit_preview()
    local node = api.tree.get_node_under_cursor()

    if node.nodes ~= nil then
      -- expand or collapse folder
      api.node.open.edit()
    else
      -- open file as vsplit
      api.node.open.vertical()
    end

    -- Finally refocus on tree if it was lost
    api.tree.focus()
  end

  local git_add = function()
    local node = api.tree.get_node_under_cursor()
    local gs = node.git_status.file

    -- If the current node is a directory get children status
    if gs == nil then
      gs = (node.git_status.dir.direct ~= nil and node.git_status.dir.direct[1]) or (node.git_status.dir.indirect ~= nil and node.git_status.dir.indirect[1])
    end

    -- If the file is untracked, unstaged or partially staged, we stage it
    if gs == '??' or gs == 'MM' or gs == 'AM' or gs == ' M' then
      vim.cmd('silent !git add ' .. node.absolute_path)

      -- If the file is staged, we unstage
    elseif gs == 'M ' or gs == 'A ' then
      vim.cmd('silent !git restore --staged ' .. node.absolute_path)
    end

    api.tree.reload()
  end
  local swap_then_open_tab = function()
    local node = api.tree.get_node_under_cursor()
    vim.cmd 'wincmd l'
    api.node.open.tab(node)
  end
  -- { key = "t", action = "swap_then_open_tab", action_cb = swap_then_open_tab },
  -- Default mappings. Feel free to modify or remove as you wish.
  --
  -- BEGIN_DEFAULT_ON_ATTACH
  vim.keymap.set('n', '<C-k>', api.node.show_info_popup, opts 'Info')
  vim.keymap.set('n', '<CR>', api.node.open.edit, opts 'Open')
  vim.keymap.set('n', 't', open_buf_as_tab, opts 'Open: New Tab')
  vim.keymap.set('n', '<C-e>', api.node.open.replace_tree_buffer, opts 'Open: In Place')
  vim.keymap.set('n', '<C-v>', api.node.open.vertical, opts 'Open: Vertical Split')
  vim.keymap.set('n', '<C-x>', api.node.open.horizontal, opts 'Open: Horizontal Split')
  vim.keymap.set('n', 'q', api.tree.close, opts 'Close')
  vim.keymap.set('n', 'a', api.fs.create, opts 'Create')
  vim.keymap.set('n', 'r', api.fs.rename, opts 'Rename')
  vim.keymap.set('n', 'R', api.tree.reload, opts 'Refresh')
  vim.keymap.set('n', 'c', api.fs.copy.node, opts 'Copy file/folder')
  vim.keymap.set('n', 'x', api.fs.cut, opts 'Cut')
  vim.keymap.set('n', 'y', api.fs.copy.filename, opts 'Copy Name')
  vim.keymap.set('n', 'Y', api.fs.copy.relative_path, opts 'Copy Relative Path')
  vim.keymap.set('n', 'p', api.fs.paste, opts 'Paste')
  vim.keymap.set('n', 'd', api.fs.remove, opts 'Delete')
  vim.keymap.set('n', 'D', api.fs.trash, opts 'Trash')
  vim.keymap.set('n', 'E', api.tree.expand_all, opts 'Expand All')
  vim.keymap.set('n', 'C', api.tree.change_root_to_node, opts 'Set Current Directory as Root')
  vim.keymap.set('n', '-', api.tree.change_root_to_parent, opts 'Set Parent Directory as Root')
  vim.keymap.set('n', '<BS>', api.node.navigate.parent_close, opts 'Close Directory')
  vim.keymap.set('n', '<C-r>', api.fs.rename_sub, opts 'Rename: Omit Filename')
  vim.keymap.set('n', 'e', api.fs.rename_basename, opts 'Rename: Basename')
  vim.keymap.set('n', 'K', api.node.navigate.sibling.first, opts 'First Sibling')
  vim.keymap.set('n', '>', api.node.navigate.sibling.next, opts 'Next Sibling')
  vim.keymap.set('n', '<', api.node.navigate.sibling.prev, opts 'Previous Sibling')
  vim.keymap.set('n', 'J', api.node.navigate.sibling.last, opts 'Last Sibling')
  -- vim.keymap.set('n', 'o', api.node.open.edit, opts 'Open')
  vim.keymap.set('n', 'Z', api.node.run.system, opts 'Run System')
  vim.keymap.set('n', '.', api.node.run.cmd, opts 'Run Command')
  vim.keymap.set('n', 'm', api.marks.toggle, opts 'Toggle Bookmark')
  vim.keymap.set('n', 'bmv', api.marks.bulk.move, opts 'Move Bookmarked')
  vim.keymap.set('n', 'B', api.tree.toggle_no_buffer_filter, opts 'Toggle No Buffer')
  vim.keymap.set('n', 'G', api.tree.toggle_git_clean_filter, opts 'Toggle Git Clean')
  vim.keymap.set('n', 'ga', git_add, opts 'Git Add')
  vim.keymap.set('n', '[c', api.node.navigate.git.prev, opts 'Prev Git')
  vim.keymap.set('n', ']c', api.node.navigate.git.next, opts 'Next Git')
  vim.keymap.set('n', ']e', api.node.navigate.diagnostics.next, opts 'Next Diagnostic')
  vim.keymap.set('n', '[e', api.node.navigate.diagnostics.prev, opts 'Prev Diagnostic')
  vim.keymap.set('n', 'f', api.live_filter.start, opts 'Filter')
  vim.keymap.set('n', 'F', api.live_filter.clear, opts 'Clean Filter')
  vim.keymap.set('n', 'g?', api.tree.toggle_help, opts 'Help')
  vim.keymap.set('n', 'gy', api.fs.copy.absolute_path, opts 'Copy Absolute Path')
  vim.keymap.set('n', 'hd', api.tree.toggle_hidden_filter, opts 'Toggle Dotfiles')
  vim.keymap.set('n', 'I', api.tree.toggle_gitignore_filter, opts 'Toggle Git Ignore')
  vim.keymap.set('n', 'O', api.node.open.no_window_picker, opts 'Open: No Window Picker')
  vim.keymap.set('n', 'P', api.node.navigate.parent, opts 'Parent Directory')
  -- vim.keymap.set('n', 's', api.node.run.system, opts 'Run System')
  vim.keymap.set('n', 'S', api.tree.search_node, opts 'Search')
  vim.keymap.set('n', 'U', api.tree.toggle_custom_filter, opts 'Toggle Hidden')
  vim.keymap.set('n', 'W', api.tree.collapse_all, opts 'Collapse')
  vim.keymap.set('n', 'H', api.tree.collapse_all, opts 'Collapse All')
  -- vim.keymap.set('n', '<2-LeftMouse>', api.node.open.edit, opts 'Open')
  -- vim.keymap.set('n', '<2-RightMouse>', api.tree.change_root_to_node, opts 'CD')
  -- END_DEFAULT_ON_ATTACH
  vim.keymap.set('n', 'l', edit_or_open, opts 'Edit Or Open')
  vim.keymap.set('n', 'L', vsplit_preview, opts 'Vsplit Preview')
  -- vim.keymap.set('n', 'h', api.tree.close, opts 'Close')
  -- Mappings removed via:
  --   remove_keymaps
  --   OR
  --   view.mappings.list..action = ""
  --
  -- The dummy set before del is done for safety, in case a default mapping does not exist.
  --

  -- Mappings migrated from view.mappings.list
  --
  -- You will need to insert "your code goes here" for any mappings with a custom action_cb
  -- vim.keymap.set('n', 'A', api.tree.expand_all, opts 'Expand All')
  -- vim.keymap.set('n', '?', api.tree.toggle_help, opts 'Help')
  vim.keymap.set('n', 'P', function()
    local node = api.tree.get_node_under_cursor()
    print(node.absolute_path)
  end, opts 'Print Node Path')
end

-- require('nvim-tree').setup {
--   on_attach = on_attach,
--   sync_root_with_cwd = true,
--   filters = {
--     git_ignored = false,
--     dotfiles = false,
--     git_clean = false,
--     no_buffer = false,
--     custom = {},
--     exclude = {},
-- },
-- }
local HEIGHT_RATIO = 0.8 -- You can change this
local WIDTH_RATIO = 0.5 -- You can change this too

require('nvim-tree').setup {
  on_attach = my_on_attach,
  sync_root_with_cwd = true,
  hijack_directories = {
    auto_open = false,
  },
  filters = {
    git_ignored = false,
    dotfiles = false,
    git_clean = false,
    no_buffer = false,
    custom = {},
    exclude = {},
  },
  view = {
    float = {
      enable = true,
      open_win_config = function()
        local screen_w = vim.opt.columns:get()
        local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
        local window_w = screen_w * WIDTH_RATIO
        local window_h = screen_h * HEIGHT_RATIO
        local window_w_int = math.floor(window_w)
        local window_h_int = math.floor(window_h)
        local center_x = (screen_w - window_w) / 2
        local center_y = ((vim.opt.lines:get() - window_h) / 2) - vim.opt.cmdheight:get()
        return {
          border = 'rounded',
          relative = 'editor',
          row = center_y,
          col = center_x,
          width = window_w_int,
          height = window_h_int,
        }
      end,
    },
    width = function()
      return math.floor(vim.opt.columns:get() * WIDTH_RATIO)
    end,
  },
}

-- Open as a float on directory such that switching to Telescope doesn't throw errors
local function open_nvim_tree(data)
  -- buffer is a directory
  local directory = vim.fn.isdirectory(data.file) == 1

  if not directory then
    return
  end

  -- create a new, empty buffer
  vim.cmd.enew()

  -- wipe the directory buffer
  vim.cmd.bw(data.buf)

  -- change to the directory
  vim.cmd.cd(data.file)

  -- open the tree
  require('nvim-tree.api').tree.open()
end

vim.api.nvim_create_autocmd({ 'VimEnter' }, { callback = open_nvim_tree })
