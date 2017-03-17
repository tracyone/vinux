# 🍎 t-vim [![Build Status](https://travis-ci.org/tracyone/t-vim.svg?branch=master)](https://travis-ci.org/tracyone/t-vim)

![screenshot](https://cloud.githubusercontent.com/assets/4246425/23589032/5d9e2a48-0201-11e7-999e-393185ae3a25.png)

**Quick Install**

	git clone https://github.com/tracyone/t-vim ~/.vim


**Wiki**

[t-vim's wiki](https://github.com/tracyone/t-vim/wiki)

**Content**

<!-- vim-markdown-toc GFM -->
* [Installation](#installation)
* [Feature introduction](#feature-introduction)
* [Feature Config](#feature-config)
	* [Enable or disable feature](#enable-or-disable-feature)
	* [Enable feature at runtime](#enable-feature-at-runtime)
	* [Add new feature](#add-new-feature)

<!-- vim-markdown-toc -->

#  Installation

Dependency see :[Install-external-dependency](https://github.com/tracyone/t-vim/wiki/Install-external-dependency)

Execute following shell script,it will do following things:

1. make some softlink of vim and neovim config
2. ask you to choose a complete plugin then try to install it.

You can launch vim, all stuff will be installed automatically.

```bash
# for macOS and linux
./install.sh
```

It is difficult to install some plugins like YouCompleteMe and other complete
plugin ,`install.sh` accept
one integer argument which indicate the complete plugin:

```bash
# 1-->ycm, 2-->clang_complete, 3-->completor.vim, 4-->neocomplete, 5-->deoplete.nvim
./install.sh 1
```

# Feature introduction

1. c/c++ source code complete and GoToDefinition. see [Source code reading and GoToDefinition](https://github.com/tracyone/t-vim/wiki/Keymapping#source-code-reading-and-gotodefinition)
3. Viml autocomplete and GoToDefinition (see [Shougo/neco-vim](https://github.cim/Shougo/neco-vim))
4. Markdown syntax highlight,preview and TOC.(see [markdown](https://github.com/tracyone/t-vim/wiki/Keymapping#markdown))
5. Run external command asynchronously.Include generating cscope database，cctree database.(Use [tracyone/neomake-multiprocess](https://github.com/tracyone/neomake-multiprocess))
6. Ctrlp+ag+ctrlp-py-matcher+ctrlp-funky:high speed fuzzy searcher，search
   anything you want.(see [ctrlp](https://github.com/tracyone/t-vim/wiki/Keymapping#ctrlp) and [fuzzy-files-search-string-search](https://github.com/tracyone/t-vim/wiki/Keymapping#fuzzy-files-search--string-search))
7. Spacemacs like keybinding.(SPC+hk or SPC+? show the key guide, also see [Keymapping with space prefix](https://github.com/tracyone/t-vim/wiki/Keymapping#keymapping-with-space-prefix))
8. Some most use options can be toggled and saved without modifying vim's
   config.(see [tracyone/love.vim](https://github.com/tracyone/love.vim) and [Toggle something](https://github.com/tracyone/t-vim/wiki/Keymapping#toggle-something))
9. Do most of git operation in Vim.(see [git-relate](https://github.com/tracyone/t-vim/wiki/Keymapping#git-relate))
10. Smoothly switch window between vim and tmux.
11. Smoothly switch buffers and tabs.(see [windows operation](https://github.com/tracyone/t-vim/wiki/Keymapping#windows-operatting))
12. [GNU Readline keybinding](https://cnswww.cns.cwru.edu/php/chet/readline/readline.html) in vim's insert mode and command line mode.
13. Syntax check function that is provided by [neomake](https://github.com/neomake/neomake).
14. many other feature please see the [wiki](https://github.com/tracyone/t-vim/wiki)


# Feature Config

## Enable or disable feature

`$VIMFILES/feature.vim` is the feature config file.There are all the features showing below.

```vim
let g:feat_enable_tools=1
let g:feat_enable_frontend=0
let g:feat_enable_complete=1
let g:feat_enable_airline=1
let g:feat_enable_edit=1
let g:complete_plugin_type='ycm'
let g:feat_enable_c=1
let g:feat_enable_jump=1
let g:feat_enable_basic=1
let g:feat_enable_vim=1
let g:feat_enable_gui=1
let g:feat_enable_tmux=1
let g:airline_powerline_fonts=1
let g:feat_enable_help=1
let g:feat_enable_markdown=1
let g:feat_enable_git=1
```


Format:

```vim
"enable 
let g:feat_enable_<name>=1
"disable
let g:feat_enable_<name>=0
```

`$VIMFILES/rc/<name>.vim` will be sourced when `g:feat_enable_<name>` equal to 1


## Enable feature at runtime

Shutcut: `<SPC>+fe` or

```vim
:call te#feat#feat_dyn_enable()
```


## Add new feature

1. Add following line to `vimrc` between `plug#begin` and `plug#end`

    ```vim
    call te#feat#feat_enable('g:feat_enable_<name>', <default>)
    ```

2. Create  `$VIMFILES/rc/<name>.vim`

3. Add package info and package info, example:

```vim
"package info
Plug 'Shougo/neco-vim'
Plug 'mhinz/vim-lookup', {'for': 'vim'}
"package config
nnoremap <silent> <c-]>  :call lookup#lookup()<cr>
nnoremap <silent> <c-t>  :call lookup#pop()<cr>
```

