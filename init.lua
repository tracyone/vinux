--File       init.lua
--Brief      Entry file of neovim
--Date       2015-11-28/22:56:20
--Author     tracyone,tracyone@live.cn,
--Github     https://github.com/tracyone/vinux
vim.api.nvim_command("source ".. vim.fn.fnamemodify(vim.fn.expand('<sfile>'), ':p:h').."/vimrc")

