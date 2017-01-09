# t-vim 

[![Build Status](https://travis-ci.org/tracyone/t-vim.svg?branch=master)](https://travis-ci.org/tracyone/t-vim)

![screenshot](https://cloud.githubusercontent.com/assets/4246425/21648505/36a89600-d2d9-11e6-8dcf-9941e114c783.png)

**Quick Install**

	git clone https://github.com/tracyone/t-vim ~/.vim

<!-- vim-markdown-toc GFM -->
* [Installation](#installation)
* [Feature introduction](#feature-introduction)
* [Keymapping](#keymapping)
	* [Keymapping with space prefix](#keymapping-with-space-prefix)
		* [Application](#application)
		* [Buffer](#buffer)
		* [Comment operating](#comment-operating)
		* [Easymotion mapping](#easymotion-mapping)
		* [File releate](#file-releate)
		* [Ctrlp](#ctrlp)
		* [Git relate](#git-relate)
		* [Help relate](#help-relate)
		* [Session](#session)
		* [Markdown](#markdown)
		* [Quit](#quit)
		* [Toggle something](#toggle-something)
		* [Ag searcher](#ag-searcher)
		* [Windows operatting](#windows-operatting)
		* [Mark](#mark)
		* [Others](#others)
	* [Fuzzy files search & string search](#fuzzy-files-search--string-search)
	* [FunctionKey](#functionkey)
	* [Source code reading and GoToDefinition](#source-code-reading-and-gotodefinition)
	* [keymapping with alt prefix](#keymapping-with-alt-prefix)
	* [Other keymapping](#other-keymapping)
* [Awesome colorscheme](#awesome-colorscheme)
* [Plugin list](#plugin-list)
* [Config Structure](#config-structure)

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

Execute following shell script then start vim,it will install all stuff automatically.


```bash
# for macOS and linux
./install.sh
```

It is difficult to install some plugins like YouCompleteMe and other complete
plugin ,`install.sh` accept
one integer argument which indicate the complete plugin.

If no argument pass to `install.sh`,it will ask you to choose a complete plugin,then try to install them.


```bash
# Install YouCompleteMe 
./install.sh 1
```

# Feature introduction

1. c/c++ GotoDefinition more accurate.I combine YCM' GotoDefinition function
   with cscope together，see [Source code reading and GoToDefinition](#source-code-reading-and-gotodefinition)
2. c/c++ complete more accurate.(see [Valloric/YouCompleteMe](https://github.com/Valloric/YouCompleteMe))
3. Viml autocomplete and GoToDefinition (see [Shougo/neco-vim](https://github.cim/Shougo/neco-vim))
4. Markdown syntax highlight,preview and TOC
5. Run external command asynchronously.Include generating cscope database，cctree database.(Use [skywind3000/asyncrun.vim](https://github.com/skywind3000/asyncrun.vim))
6. Ctrlp+ag+ctrlp-py-matcher+ctrlp-funky:high speed fuzzy searcher，search
   anything you want.
7. Spacemacs like keybinding.(SPC+hk or SPC+? show the key guide)
8. Some most use options can be toggle and can be save without modify vim
   config,just  press SPC+lo to save options(see
   [tracyone/love.vim](https://github.com/tracyone/love.vim) and [Toggle
   something](#toggle-something)).
9. Do most of git operation in Vim.(See [Git relate](#git-relate))
10. Smoothly switch window between vim and tmux.
11. [GNU Readline keybinding](https://cnswww.cns.cwru.edu/php/chet/readline/readline.html) in vim's insert mode and command line mode.
12. many other feature please see the keybinding below.

# Keymapping

Leader key is `space`.

`<leader>hk` : show all the keybinding that with space prefix

`<leader>vc` : open vimrc.

## Keymapping with space prefix

### Application

mode  |      key | description
----  |     ---- | -----------
    n |       ac | vim calculator
    n |       ad | open calendar
    n |       af | open current file's position with default file explorer
    n |       aF | open project's(pwd) position with default file explorer
    n |       ah | hex to ascii convert
    n |       al | <Plug>(LiveEasyAlign)
    x |       al | <Plug>(LiveEasyAlign)
    n |       am | make
    n |       ap | Open plug status windows
    n |       as | Open vimshell or neovim's emulator
    n |       at | open current file's position in default terminal
    n |       aT | open project's(pwd) position in default terminal
    n |       ay | YouDao translate
    v |       ay | YouDao translate (visual mode)
    n |       aw | DrawIt


### Buffer

mode  |      key | description
----  |     ---- | -----------
    n |       bh | Open startify windows
    n |       bk | delete buffer
    n |       bn | next buffer or tab
    n |       bp | previous buffer or tab

### Comment operating

mode  |      key | description
----  |     ---- | -----------
    n |       ca | <Plug>NERDCommenterAltDelims
    n |       cA | <Plug>NERDCommenterAppend
    v |       cA | <Plug>NERDCommenterAppend
    n |       cb | <Plug>NERDCommenterAlignBoth
    v |       cb | <Plug>NERDCommenterAlignBoth
    n |       cc | <Plug>NERDCommenterComment
    v |       cc | <Plug>NERDCommenterComment
    n |       ci | <Plug>NERDCommenterInvert
    v |       ci | <Plug>NERDCommenterInvert
    n |       cl | <Plug>NERDCommenterAlignLeft
    v |       cl | <Plug>NERDCommenterAlignLeft
    n |       cm | <Plug>NERDCommenterMinimal
    v |       cm | <Plug>NERDCommenterMinimal
    n |       cn | <Plug>NERDCommenterNest
    v |       cn | <Plug>NERDCommenterNest
    n |       c$ | <Plug>NERDCommenterToEOL
    v |       c$ | <Plug>NERDCommenterToEOL
    n | c<Space> | <Plug>NERDCommenterToggle
    v | c<Space> | <Plug>NERDCommenterToggle
    n |       cs | <Plug>NERDCommenterSexy
    v |       cs | <Plug>NERDCommenterSexy
    n |       cu | <Plug>NERDCommenterUncomment
    v |       cu | <Plug>NERDCommenterUncomment
    n |       cy | <Plug>NERDCommenterYank
    v |       cy | <Plug>NERDCommenterYank


### Easymotion mapping

mode  |      key | description
----  |     ---- | -----------
    n |       ef | MultiWindow easymotion for char
    n |       el | MultiWindow easymotion for line
    n |       es | MultiChar easymotion
    n |       et | <Plug>(easymotion-tn)
    n |        F | MultiWindow easymotion for word

### File releate

mode  |      key | description
----  |     ---- | -----------
    n |       fc | cd to current buffer's path
    n |       fg | run Ag command
    n |       fj | Open Vim File Explorer
    n |       fR | rename multi file name
    n |       fS | save all
    n |       fs | save file
    n |       fU | CtrlP function

###  Ctrlp 

mode  |      key | description
----  |     ---- | -----------
    n |       pc | CtrlP cmd 
    n |       pk | CtrlP function
    n |       pl | ctrlp buffer
    n |       pp | CtrlP file
    n |       pr | CtrlP mru
    n |       pt | CtrlP tmux session

### Git relate

mode  |      key | description
----  |     ---- | -----------
    n |       gb | Open git blame windows
    n |       gd | git diff current file (vimdiff)
    n |       gh | Open github url
    n |       gi | list git issue
    n |       gl | Open git log( browser mode)
    n |       gL | Open git log(file mode)
    v |       gL | Open git log(file mode)
    n |       gp | git push origin master
    n |       gs | Open git status window

### Help relate

mode  |      key | description
----  |     ---- | -----------
    n |       hk | **list leader's map**
    n |       ?  | **list leader's map**
    n |       hm | **manpage or vimhelp on current curosr word**
    n |       he | open eval.txt in new tab
    n |       hf | open vim function-list in new tab
    n |       hp | open vim script manual in new tab

### Session

mode  |      key | description
----  |     ---- | -----------
    n |       ll | **Session load**
    n |       lo | **Save basic setting**
    n |       ls | **Session save**

### Markdown

mode  |      key | description
----  |     ---- | -----------
    n |       mp | Markdown preview in browser
    n |       mt | generate markdown TOC
    n |       mu | update markdown TOC
    n |       ms | show toc in sidebar

### Quit

mode  |      key | description
----  |     ---- | -----------
    n |       qq | quit all
    n |       qQ | quit all without save
    n |       qs | save and quit all

### Toggle something

`Can be save` mean after toggle you can press SPC+lo to save your setting
without modify any config.

mode  |      key | description
----  |     ---- | -----------
    n |       tb | background dark or light toggle (**Can be save**)
    n |       td | dos to unix or unix to dos
    n |       tf | Convert file's encode
    n |       tg | **menu and toolbar toogle** (**Can be save**)
    n |       tm | Mouse mode toggle (**Can be save**)
    n |       te | Open nerd tree
    n |       tn | toggle line number (**Can be save**)
    n |       to | toggle free writing in vim (Goyo)
    n |       tt | Open tagbar
    n |       th | realtime underline word toggle
    n |       tu | undo tree window toggle
    n |       tc | toggle between tab or space,8 or 4 (**Can be save**)
    n |       tp | toggle paste option
    n |       tj | whether use cache in ctrlp

### Ag searcher

mode  |      key | description
----  |     ---- | -----------
    n |       vf | ag search c family function
    n |       vt | ag search :TODO or FIXME
    n |       vv | ag search for the word on current curosr
    v |       vv | ag search for the word on current curosr

### Windows operatting

mode  |      key | description
----  |     ---- | -----------
    n |        1 | tab 1
    n |        2 | tab 2
    n |        3 | tab 3
    n |        4 | tab 4
    n |        5 | tab 5
    n |        6 | tab 6
    n |        7 | tab 7
    n |        8 | tab 8
    n |        9 | tab 9
    n |       wc | **Choose windows**
    n |       wd | hide current windows
    n |       wh | move to left win
    n |       wj | move down win
    n |       wk | move up win
    n |       wl | move to right win
    n |       wm | maxsize of current windows
      |       w= | :resize +10<CR>
      |       w- | :resize -10<CR>
    n |       ws | horizontal open window
    n |       wS | horizontal open window then focus the new one
      |       w, | :vertical resize -10<CR>
      |       w. | :vertical resize +10<CR>
    n |       wv | vertical open window
    n |       wV | vertical open window then focus the new one
    n |       ww | switch between two windows


### Mark 

mode  |      key | description
----  |     ---- | -----------
    n |        mm | <Plug>MarkSet
    x |        mm | <Plug>MarkSet
    n |        mn | <Plug>MarkClear
    n |        m/ | <Plug>MarkSearchAnyNext
    n |        m? | <Plug>MarkSearchAnyPrev
    n |        * | <Plug>MarkSearchCurrentNext
    n |        # | <Plug>MarkSearchCurrentPrev
    n |        r | <Plug>MarkRegex
    x |        r | <Plug>MarkRegex

### Others 

mode  |      key | description
----  |     ---- | -----------
    n |        d | :YcmShowDetailedDiagnostic<CR>
    n |      iav | Open c family header in new tab
    n |       jl | jume to definition (YCM)
    n |        o | open url on cursor with default browser
    n |       vc | **open the vimrc in tab**
    n |       so | **update the _vimrc**
    n |      fml | Open Leader mappings in new window
    n |       yr | run cunrrent file
    v |       yr | run selection text
    n |       yy | Open Yanking windows or ctrlp-register

## Fuzzy files search & string search

[ctrlpvim](https://github.com/ctrlpvim/ctrlp.vim)

[ctrlp-funky](https://github.com/tacahiroy/ctrlp-funky)

ShortCut Key  | mode          | Description
---------     | ----------    | ---------------
 `Ctrl-p`     | normal        | fuzzy search files
 `Ctrl-k`     | normal        | fuzzy search functions for current file
 `Ctrl-j`     | normal        | fuzzy search buffers
 `Ctrl-l`     | normal        | fuzzy search recent open files(MRU)
 `<leader>vv` | normal,visual | global search string under cursor
 `<leader>vf` | normal        | global search string c function under cursor
 `<leader>vt` | normal        | global search **TODO** or **FIXME**

 For speed up the search process,recommand you install [the silver searcher](https://github.com/ggreer/the_silver_searcher).

 You can substitute in the search result of ag.
 
 Press **r** in the quickfix windows,it will enter to the **qfreplace** mode,press ctrl-n on the cursor word it will enter to the multi-cursor mode,modify then save.

## FunctionKey

ShortCut Key | mode          | Description
---------    | ----------    | ---------------
`F1`         | all           | Open vim help
`F2`         | all           | Open rename windows
`F3`         | all           | Open Gstatus windows
`F4`         | all           | Open shell,or terminal emulator
`F5`         | all           | Execute make then open quickfix
`F6`         | normal,visual | execute current file or selection code
`F7`         | normal        | perform dos2unix or unix2dos for current open file.
`F8`         | all           | save current session
`F9`         | normal        | open tagbar windows
`F10`        | normal,visual | YouDao dict translate the word under the cursor
`F11`        | normal        | Open vim file manager
`F12`        | normal,insert | open nerdtree

## Source code reading and GoToDefinition

Function                                              | ShortCut Key
 ---------                                            | ------------
Generate database                                     | `,u`
add database under the cur dir                        | `,a`,split view:`<C-\>a`
GotoDefinition  under the cursor                      | `,g`,split view:`<C-\>g`
Find functions calling this function under the cursor | `,c`,split view:`<C-\>c`

**t-vim** will automatically add cscope.out under the current directory.

**t-vim** will add all cscope.out which path is specified by file `.project` under the current directory.

File `.project` format:

```
/home/tracyone/work/ctest/
/usr/inculde/
```

if file `.project` is exist at the current directory,when press `,u` **t-vim** will ask whether Generate database for specified path in `.project`.

When press `,g`,**t-vim** will try to use the function of YouCompleteMe GoToDefinition,if it failed,then use cscope.

## keymapping with alt prefix

mode | key  | description
---- | ---- | -----------
n    | 1    | tab 1
n    | 2    | tab 2
n    | 3    | tab 3
n    | 4    | tab 4
n    | 5    | tab 5
n    | 6    | tab 6
n    | 7    | tab 7
n    | 8    | tab 8
n    | 9    | tab 9
n    | t    | new tab
n    | q    | nohls
n    | a    | select all
n    | =    | select all then align
n    | h    | move to left win
n    | l    | move to right win
n    | j    | move to down win
n    | k    | move to up win
i    | h    | equal to `<left>` in insert mode
i    | l    | equal to `<right>` in insert mode
i    | j    | equal to `<down>` in insert mode
i    | k    | equal to `<up>` in insert mode
i    | b    | words backward.
i    | f    | words forward.
c    | h    | characters to the left.
c    | l    | characters to the right.
c    | j    | characters to the down.
c    | k    | characters to the up.
c    | b    | words backward.
c    | f    | words forward.
n    | m    | mouse enable toggle

## Other keymapping

mode | key  | description
---- | ---- | -----------
n,i    | C-y    | Yanking win or ctrlp-register
n | C-h | substitute the cursor word
n | C-n | Multicusor mode toggle
n | C-y | open yankring windows or ctrlp-register in neovim.
i | C-j | ultisnips expand or jump forward to next selection in ultisnips
i | C-k | jump backward to the  selection in ultisnips
n | sj  | equal to za,toggle fold
n | sk | equal to zM,fold all
n | si | fold enable toggle
n | k | find help on vim document or man page.


# Awesome colorscheme

[sjl/badwolf](https://github.com/sjl/badwolf)

[altercation/vim-colors-solarized](https://github.com/altercation/vim-colors-solarized)

[tomasr/molokai](https://github.com/tomasr/molokai)

[morhetz/gruvbox](https://github.com/morhetz/gruvbox)

[NLKNguyen/papercolor-theme](https://github.com/NLKNguyen/papercolor-theme) (default)

[KabbAmine/yowish.vim](https://github.com/KabbAmine/yowish.vim)

# Plugin list

**Lifechanging plugins**

- [Valloric/YouCompleteMe](https://github.com/Valloric/YouCompleteMe):Complete engine.

- [easymotion/vim-easymotion](https://github.com/easymotion/vim-easymotion):Move your cursor to any position that you want.

- [terryma/vim-multiple-cursors](https://github.com/terryma/vim-multiple-cursors):Sublime text like function.

- [ctrlpvim/ctrlp.vim](https://github.com/ctrlpvim/ctrlp.vim):Fuzzy Searcher

- [FelikZ/ctrlp-py-matcher](https://github.com/FelikZ/ctrlp-py-matcher):Speed up the ctrlp

- [tacahiroy/ctrlp-funky](https://github.com/tacahiroy/ctrlp-funky):ctrlp's extension for listing functions of current file.

- [SirVer/ultisnips](https://github.com/SirVer/ultisnips):Code snippets engine

- [junegunn/vim-easy-align](https://github.com/junegunn/vim-easy-align):Align text.The tables in current markdown file are aligned by this plugin

- [thinca/vim-qfreplace](https://github.com/thinca/vim-qfreplace):replcae text in multiple files.

- [Shougo/vimshell.vim](https://github.com/Shougo/vimshell.vim):shell

- [skywind3000/asyncrun.vim](https://github.com/skywind3000/asyncrun.vim):run external command asynchrounsly,support vim8 and neovim

- [mhinz/vim-startify](https://github.com/mhinz/vim-startify):start screen,session manager,mru manager

**others**

[tracyone/a.vim](https://github.com/tracyone/a.vim)

[rdnetto/YCM-Generator](https://github.com/rdnetto/YCM-Generator)

[Shougo/neocomplete](https://github.com/Shougo/neocomplete)

[tracyone/dict](https://github.com/tracyone/dict)

[Konfekt/FastFold](https://github.com/Konfekt/FastFold)

[tracyone/hex2ascii.vim](https://github.com/tracyone/hex2ascii.vim)

[vim-scripts/verilog.vim](https://github.com/vim-scripts/verilog.vim)

[thinca/vim-quickrun](https://github.com/thinca/vim-quickrun)

[thinca/vim-fontzoom](https://github.com/thinca/vim-fontzoom)

[osyo-manga/vim-over](https://github.com/osyo-manga/vim-over)

[ashisha/image.vim](https://github.com/ashisha/image.vim)

[terryma/vim-expand-region](https://github.com/terryma/vim-expand-region)

[fisadev/vim-ctrlp-cmdpalette](https://github.com/fisadev/vim-ctrlp-cmdpalette)

[tpope/vim-fugitive](https://github.com/tpope/vim-fugitive)

[gregsexton/gitv](https://github.com/gregsexton/gitv)

[jaxbot/github-issues.vim](https://github.com/jaxbot/github-issues.vim)

[vim-scripts/delimitMate.vim](https://github.com/vim-scripts/delimitMate.vim)

[vim-scripts/genutils](https://github.com/vim-scripts/genutils)

[itchyny/calendar.vim](https://github.com/itchyny/calendar.vim)

[arecarn/selection.vim' ](https://github.com/arecarn/selection.vim)

[arecarn/crunch.vim](https://github.com/arecarn/crunch.vim)

[youjumpiwatch/vim-neoeclim](https://github.com/youjumpiwatch/vim-neoeclim)

[ianva/vim-youdao-translater](https://github.com/ianva/vim-youdao-translater)

[iamcco/markdown-preview.vim](https://github.com/iamcco/markdown-preview.vim)

[mzlogin/vim-markdown-toc](https://github.com/mzlogin/vim-markdown-toc)

[christoomey/vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator)

[lucidstack/ctrlp-tmux.vim](https://github.com/lucidstack/ctrlp-tmux.vim)

[vim-scripts/sudo.vim](https://github.com/vim-scripts/sudo.vim)

[nhooyr/neoman.vim](https://github.com/nhooyr/neoman.vim)

[tracyone/pyclewn_linux](https://github.com/tracyone/pyclewn_linux)

[CodeFalling/fcitx-vim-osx](https://github.com/CodeFalling/fcitx-vim-osx)

[Shougo/vimproc.vim](https://github.com/Shougo/vimproc.vim)

[vim-scripts/YankRing.vim](https://github.com/vim-scripts/YankRing.vim)

[mattn/ctrlp-register](https://github.com/mattn/ctrlp-register)

[vim-scripts/The-NERD-Commenter](https://github.com/vim-scripts/The-NERD-Commenter)

[scrooloose/nerdtree](https://github.com/scrooloose/nerdtree)

[kshenoy/vim-signature](https://github.com/kshenoy/vim-signature)

[tpope/vim-surround](https://github.com/tpope/vim-surround)

[majutsushi/tagbar](https://github.com/majutsushi/tagbar)

[mbbill/undotree](https://github.com/mbbill/undotree)

[vim-scripts/L9](https://github.com/vim-scripts/L9)

[mattn/emmet-vim](https://github.com/mattn/emmet-vim)

[adah1972/fencview](https://github.com/adah1972/fencview)

[vim-scripts/DrawIt](https://github.com/vim-scripts/DrawIt)

[mbbill/VimExplorer](https://github.com/mbbill/VimExplorer)

[vim-scripts/renamer.vim](https://github.com/vim-scripts/renamer.vim)

[hari-rangarajan/CCTree](https://github.com/hari-rangarajan/CCTree)

[tracyone/mark.vim](https://github.com/tracyone/mark.vim)

[tracyone/MyVimHelp](https://github.com/tracyone/MyVimHelp)

[tpope/vim-repeat](https://github.com/tpope/vim-repeat)

[Shougo/vinarise.vim](https://github.com/Shougo/vinarise.vim)

[tracyone/love.vim](https://github.com/tracyone/love.vim)

[t9md/vim-choosewin](https://github.com/t9md/vim-choosewin)

[itchyny/vim-cursorword](https://github.com/itchyny/vim-cursorword)

[justinmk/vim-gtfo'](https://github.com/justinmk/vim-gtfo)

[ktonga/vim-follow-my-lead](https://github.com/ktonga/vim-follow-my-lead)

[haya14busa/incsearch.vim](https://github.com/haya14busa/incsearch.vim)

[haya14busa/vim-asterisk](https://github.com/haya14busa/vim-asterisk)

[junegunn/goyo.vim](https://github.com/junegunn/goyo.vim)

[Shougo/neco-vim](https://github.cim/Shougo/neco-vim)

# Config Structure

![structure](https://cloud.githubusercontent.com/assets/4246425/16357646/0b8c9814-3b2f-11e6-8f21-b6247e4e6e02.png)

Open file `vimrc` with vim,it will be  folded automatically, you can press `za`(vim normal mode) to open or close fold.

- System Check:OS,vim IO,vim type check

- Basic Setting:vim basic setting like show line number,status line,backup file encode ...

- Key mapping: vim basic key mapping( exclude plugins's keymapping )

- Plugin setting:Plugins's setting

- Function:Some useful vim function

- Gui releate:gvim,macvim,font,mouse setting....

