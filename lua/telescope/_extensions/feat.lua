local has_telescope, telescope = pcall(require, 'telescope')
if not has_telescope then
  error('This plugin requires nvim-telescope/telescope.nvim')
end

return telescope.register_extension {
  exports = {
    feat = require("telescope._extensions.feat.feat").search,
  }
}

