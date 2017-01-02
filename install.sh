#!/bin/bash
# Installation shell script for linux and MacOS
# date:2016-10-12 16:08 

# Functions definiton {{{
# InstallPlugin
# argument:$1:plugin name,<github_id/reponame>
function InstallPlugin()
{
	if [[ $# -ne 1 ]]; then
		return 1;
	fi

	local id_name=${1%/*}
	local repo_name=${1#*/}

	echo -e "======= ${repo_name} installation ======== \n"

	if [[ ! -d "${HOME}/.vim/bundle/${repo_name}" ]]; then
		mkdir -p ${HOME}/.vim/bundle/${repo_name}
		git clone --depth=1 https://github.com/$1 ${HOME}/.vim/bundle/${repo_name} || return 2
    else
        echo -e "${repo_name} has been installed!\n"
	fi
	return 0
}

# InstallYCM:
# argument:NONE
function InstallYCM()
{
	InstallPlugin "Valloric/YouCompleteMe"

	if [[ -f "${HOME}/.vim/bundle/YouCompleteMe/third_party/ycmd/ycm_core.so" ]]; then
		echo -e "YouCompleteMe has already been installed.\n"
		echo -e "Finish! Happy Vim hacking.\n"
		return 0
	fi

	echo -e "Start install YouCompleteMe\n"

	cd  ${HOME}/.vim/bundle/YouCompleteMe

	git submodule update --init --recursive && ./install.py --clang-completer --tern-completer || return 1

    echo -e "Finish! Happy Vim hacking.\n"

    return 0
}

# }}}

stty erase ^H

echo -e "Create soft link for neovim\n" 
mkdir -p ${HOME}/.vim ${HOME}/.config/nvim ${HOME}/.vim/autoload
ln -sf ${HOME}/.vim ${HOME}/.config/nvim
ln -sf $(pwd)/vimrc ${HOME}/.config/nvim/init.vim
ln -sf $(pwd)/autoload/te ${HOME}/.vim/autoload/

echo -e "Create soft link for linux and mac\n"
ln -sf $(pwd)/vimrc ${HOME}/.vim/

if [[ $# -gt 1 ]]; then
    echo -e "Wrong argument\n"
    exit  1
fi

if [[ ! -z $1 ]]; then
    choose=$1
else
    echo -e "Which comlete plugin do you want to install? \n"
    echo -e "[1] YouCompleteMe(clang,complicated and powerful)\n"
    echo -e "[2] clang_complete(clang)\n"
    echo -e "[3] completor.vim(vim8)\n"
    echo -e "[4] neocomplete.vim(lua)\n"
    echo -e "[5] deoplete.nvim(neovim)\n"
    read -n1 -p "Enter number: " choose
    echo -e "\n"

fi


stty erase ^?

case ${choose} in
	1 )
		InstallYCM
		;;
	2 )
		InstallPlugin "Rip-Rip/clang_complete"
		;;
	3 )
		InstallPlugin "maralla/completor.vim"
		;;
	4 )
		InstallPlugin "Shougo/neocomplete.vim"
		;;
	5 )
		InstallPlugin "Shougo/deoplete.nvim"
		;;
	* )
		echo -e "Wrong number!\n";exit 2
		;;
esac

if [[ $? -ne 0 ]]; then
    echo -e "Install plugin failed\n";exit 3
fi

echo ${choose} > ${HOME}/.vim/.complete_plugin

# vim: set fdm=marker foldlevel=0 foldmarker& filetype=vim: 
