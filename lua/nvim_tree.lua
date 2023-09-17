
local function my_on_attach(bufnr)
  local api = require "nvim-tree.api"

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- default mappings
  api.config.mappings.default_on_attach(bufnr)

  -- custom mappings
  vim.keymap.set('n', '<C-t>', api.tree.change_root_to_parent,        opts('Up'))
  vim.keymap.set('n', 't', api.node.open.tab,                     opts('Open: New Tab'))
  vim.keymap.set('n', 'yy',     api.fs.copy.node,                      opts('Copy'))
  vim.keymap.set('n', '?',    api.tree.toggle_help,                  opts('Help'))
  vim.keymap.set('n', 'N',     api.fs.create,                         opts('Create'))
  vim.keymap.set('n', 'b',     api.marks.toggle,                      opts('Toggle Bookmark'))
  vim.keymap.set('n', 'm',     api.fs.cut,                            opts('Cut'))
end

-- pass to setup along with your other options
require("nvim-tree").setup {
    disable_netrw = false,
    on_attach = my_on_attach,
}
return module
