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
	* [Add new feature](#add-new-feature)

<!-- vim-markdown-toc -->

#  Installation

Dependency:

- [git](https://git-scm.com/downloads)
- [curl](https://curl.haxx.se/)
- [the_silver_searcher](https://github.com/ggreer/the_silver_searcher)
- [ctags](http://ctags.sourceforge.net/)
- [cscope](http://cscope.sourceforge.net/)
- [vim](http://www.vim.org/)-8.0 with python2 support.
- [neovim](https://github.com/neovim/neovim) 0.1.6 or above

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

1. c/c++ accurate complete and GoToDefinition. see [Source code reading and GoToDefinition](https://github.com/tracyone/t-vim/wiki/Keymapping#source-code-reading-and-gotodefinition)
3. Viml autocomplete and GoToDefinition (see [Shougo/neco-vim](https://github.cim/Shougo/neco-vim))
4. Markdown syntax highlight,preview and TOC
5. Run external command asynchronously.Include generating cscope database，cctree database.(Use [tracyone/neomake-multiprocess](https://github.com/tracyone/neomake-multiprocess))
6. Ctrlp+ag+ctrlp-py-matcher+ctrlp-funky:high speed fuzzy searcher，search
   anything you want.
7. Spacemacs like keybinding.(SPC+hk or SPC+? show the key guide)
8. Some most use options can be toggle and can be save without modify vim
   config,just  press SPC+lo to save options(see
   [tracyone/love.vim](https://github.com/tracyone/love.vim) and [Toggle
   something](#toggle-something)).
9. Do most of git operation in Vim.(See [Git relate](#git-relate))
10. Smoothly switch window between vim and tmux.
11. Smoothly switch buffers and tabs.
12. [GNU Readline keybinding](https://cnswww.cns.cwru.edu/php/chet/readline/readline.html) in vim's insert mode and command line mode.
13. many other feature please see the [wiki](https://github.com/tracyone/t-vim/wiki)


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


## Add new feature

1. Add following line to `vimrc` between `plug#begin` and `plug#end`

    ```vim
    call s:feat_enable('g:feat_enable_<name>', <default>)
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

