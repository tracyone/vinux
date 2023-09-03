local has_telescope, telescope = pcall(require, 'telescope')
if not has_telescope then
  error('This plugin requires nvim-telescope/telescope.nvim')
end

vim.cmd("highlight default link TelescopeTermBufNumber Number")
vim.cmd("highlight default link TelescopeTermBufName Function")

return telescope.register_extension {
  exports = {
    term = require("telescope._extensions.term.term").search,
  }
}

