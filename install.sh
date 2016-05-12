#!/bin/bash

echo -e "Create soft link for neovim\n" 
mkdir -p ~/.vim ~/.config/nvim
ln -sf ~/.vim ~/.config/nvim
ln -sf $(pwd)/vimrc ~/.config/nvim/init.vim

echo -e "Create soft link for linux and mac\n"
ln -sf $(pwd)/vimrc ~/.vimrc

echo -e "All done, Please start vim & nvim & gvim and the plugins will be installed automatically!\n"
