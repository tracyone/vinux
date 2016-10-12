#!/bin/bash
# Installation shell script for linux and MacOS
# date:2016-10-12 16:08 

echo -e "Create soft link for neovim\n" 
mkdir -p ${HOME}/.vim ${HOME}/.config/nvim
ln -sf ${HOME}/.vim ${HOME}/.config/nvim
ln -sf $(pwd)/vimrc ${HOME}/.config/nvim/init.vim

echo -e "Create soft link for linux and mac\n"
ln -sf $(pwd)/vimrc ${HOME}/.vimrc

if [[ ! -d "${HOME}/.vim/bundle/YouCompleteMe" ]]; then
    mkdir -p ${HOME}/.vim/bundle/YouCompleteMe
fi

if [[ -f "${HOME}/.vim/bundle/YouCompleteMe/third_party/ycmd/ycm_core.so" ]]; then
    echo -e "YouCompleteMe has already been installed.\n"
    exit 0
fi

echo -e "Start install YouCompleteMe\n"

cd  ${HOME}/.vim/bundle/YouCompleteMe

git submodule update --init --recursive && ./install.py --clang-completer --tern-completer  && echo -e "Finish! Happy Vim hacking."

