![screenshot](https://cloud.githubusercontent.com/assets/4246425/19315778/a08cc216-90d1-11e6-92e5-8083851b3841.png)


* [Installation](#installation)
* [Keymapping](#keymapping)
	* [keymapping with space prefix](#keymapping-with-space-prefix)
	* [Fuzzy files search & string search](#fuzzy-files-search--string-search)
	* [FunctionKey](#functionkey)
	* [Source code reading and GoToDefinition](#source-code-reading-and-gotodefinition)
	* [keymapping with alt prefix](#keymapping-with-alt-prefix)
* [Awesome colorscheme](#awesome-colorscheme)
* [Pluglist](#pluglist)
* [Config Structure](#config-structure)

#  Installation

Dependency:

- [git](https://git-scm.com/downloads)
- [curl](https://curl.haxx.se/)
- [the_silver_searcher](https://github.com/ggreer/the_silver_searcher)
- [ctags](http://ctags.sourceforge.net/)
- [cscope](http://cscope.sourceforge.net/)
- [vim](http://www.vim.org/) with python2 support.

Execute following shell script then start vim,it will install all stuff automatically.


```bash
# for macOS and linux
./install.sh
```

# Keymapping

Leader key is `space`.

`<leader>hk` : show all the keybinding that with space prefix

`<leader>vc` : open vimrc.

## keymapping with space prefix

mode  | key      | description
----  | ----     | -----------
    n | tm       | Mouse mode toggle
    n | **so**   | **update the _vimrc**
    n | **vc**   | **open the vimrc in tab**
      | w.       | :vertical resize +10<CR>
      | w,       | :vertical resize -10<CR>
      | w-       | :resize -10<CR>
      | w=       | :resize +10<CR>
    n | fc       | cd to current buffer's path
    n | cC       | make
    n | td       | dos to unix or unix to dos
    n | o        | open url on cursor with default browser
    n | ap       | Open plug status windows
    n | tt       | Open tagbar
    n | jl       | jume to definition (YCM)
    n | tn       | Open nerd tree
    n | iav      | Open c family header in new tab
    n | bl       | ctrlp buffer
    n | fr       | CtrlP mru
    n | ff       | CtrlP file
    n | fU       | CtrlP function
    n | pt       | CtrlP tmux session
    n | pk       | CtrlP function
    n | fj       | Open Vim File Explorer
    n | tf       | Convert file's encode
    n | fR       | rename multi file name
    n | as       | Open vimshell or neovim's emulator
    n | bh       | Open startify windows
    n | vv       | ag search for the word on current curosr
    v | vv       | ag search for the word on current curosr
    n | vf       | ag search c family function
    n | vt       | ag search :TODO or FIXME
    n | mp       | Markdown preview in browser
    n | mt       | generate markdown TOC
    n | gs       | Open git status window
    n | gh       | Open github url
    n | gl       | Open git log( browser mode)
    n | gL       | Open git log(file mode)
    v | gL       | Open git log(file mode)
    n | gb       | Open git blame windows
    n | gd       | git diff current file (vimdiff)
    n | gi       | list git issue
    n | gp       | git push origin master
    n | F        | MultiWindow easymotion for word
    n | es       | MultiChar easymotion
    n | et       | <Plug>(easymotion-tn)
    n | el       | MultiWindow easymotion for line
    n | ef       | MultiWindow easymotion for char
    x | al       | <Plug>(LiveEasyAlign)
    n | al       | <Plug>(LiveEasyAlign)
    n | yr       | run cunrrent file
    v | yr       | run selection text
    n | tu       | realtime underline word toggle
    n | yd       | YouDao translate
    v | yd       | YouDao translate (visual mode)
    n | ac       | vim calculator
    n | au       | undo tree window toggle
    n | ah       | hex to ascii convert
    n | bn       | next buffer or tab
    n | bp       | previous buffer or tab
    n | bk       | delete buffer
    n | bf       | open current file's position with default file explorer
    n | bt       | open current file's position with default terminal
    n | bF       | open project's(pwd) position with default file explorer
    n | bT       | open project's(pwd) position with default terminal
    n | fg       | run Ag command
    n | fs       | save file
    n | fS       | save all
    n | **hm**   | **manpage or vimhelp on current curosr word**
    n | **hk**   | **list leader's map**
    n | qq       | quit all
    n | qQ       | quit all without save
    n | qs       | save and quit all
    n | at       | open calendar
    n | to       | toggle free writing in vim (Goyo)
    n | 1        | tab 1
    n | 2        | tab 2
    n | 3        | tab 3
    n | 4        | tab 4
    n | 5        | tab 5
    n | 6        | tab 6
    n | 7        | tab 7
    n | 8        | tab 8
    n | 9        | tab 9
    n | wv       | vertical open window
    n | wV       | vertical open window then focus the new one
    n | ws       | horizontal open window
    n | wS       | horizontal open window then focus the new one
    n | wm       | maxsize of current windows
    n | wd       | hide current windows
    n | **w**        | **Choose windows**
    n | wh       | move to left win
    n | wl       | move to right win
    n | wj       | move down win
    n | wk       | move up win
    n | **ls**       | **Session save**
    n | **ll**       | **Session load**
    n | **lo**       | **Save basic setting**
    n | **tg**       | **menu and toolbar toogle**
    n | **tb**       | **background dark or light toggle**
    n | cc       | <Plug>NERDCommenterComment
    v | cc       | <Plug>NERDCommenterComment
    n | c<Space> | <Plug>NERDCommenterToggle
    v | c<Space> | <Plug>NERDCommenterToggle
    n | cm       | <Plug>NERDCommenterMinimal
    v | cm       | <Plug>NERDCommenterMinimal
    n | cs       | <Plug>NERDCommenterSexy
    v | cs       | <Plug>NERDCommenterSexy
    n | ci       | <Plug>NERDCommenterInvert
    v | ci       | <Plug>NERDCommenterInvert
    n | cy       | <Plug>NERDCommenterYank
    v | cy       | <Plug>NERDCommenterYank
    n | cl       | <Plug>NERDCommenterAlignLeft
    v | cl       | <Plug>NERDCommenterAlignLeft
    n | cb       | <Plug>NERDCommenterAlignBoth
    v | cb       | <Plug>NERDCommenterAlignBoth
    n | cn       | <Plug>NERDCommenterNest
    v | cn       | <Plug>NERDCommenterNest
    n | cu       | <Plug>NERDCommenterUncomment
    v | cu       | <Plug>NERDCommenterUncomment
    n | c$       | <Plug>NERDCommenterToEOL
    v | c$       | <Plug>NERDCommenterToEOL
    n | cA       | <Plug>NERDCommenterAppend
    v | cA       | <Plug>NERDCommenterAppend
    n | ca       | <Plug>NERDCommenterAltDelims
    n | d        | :YcmShowDetailedDiagnostic<CR>
    n | fml      | Open Leader mappings in new window
    n | m        | <Plug>MarkSet
    x | m        | <Plug>MarkSet
    n | r        | <Plug>MarkRegex
    x | r        | <Plug>MarkRegex
    n | n        | <Plug>MarkClear
    n | *        | <Plug>MarkSearchCurrentNext
    n | #        | <Plug>MarkSearchCurrentPrev
    n | /        | <Plug>MarkSearchAnyNext
    n | ?        | <Plug>MarkSearchAnyPrev

## Fuzzy files search & string search

[ctrlpvim](https://github.com/ctrlpvim/ctrlp.vim)

[ctrlp-funky](https://github.com/tacahiroy/ctrlp-funky)

[ag.vim](https://github.com/rking/ag.vim)

Function | mode | ShortCut Key
--------- | ---------- | ---------------
 `Ctrl-p` | normal  | fuzzy search files
 `Ctrl-k` | normal  | fuzzy search functions for current file
 `Ctrl-j` | normal  | fuzzy search buffers
 `Ctrl-l` | normal  | fuzzy search recent open files(MRU)
 `<leader>vv` | normal,visual | global search string under cursor
 `<leader>vf` | normal | global search string c function under cursor
 `<leader>vt` | normal | global search **TODO** or **FIXME**

 For speed up the search process,recommand you install [the silver searcher](https://github.com/ggreer/the_silver_searcher).

## FunctionKey

Function | mode | ShortCut Key
--------- | ---------- | ---------------
`F1` | all | Open vim help
`F2` | all | Open rename windows
`F3` | all | Open Gstatus windows
`F4` | all | Open shell,or terminal emulator 
`F5` | all | Execute make then open quickfix
`F6` | normal,visual | execute current file or selection code 
`F7` | normal | perform dos2unix or unix2dos for current open file.
`F8` | all | save current session 
`F9` | normal | open tagbar windows
`F10` | normal,visual | YouDao dict translate the word under the cursor
`F11` | normal | Open vim file manager
`F12` | normal,insert | open nerdtree

## Source code reading and GoToDefinition

Function |  ShortCut Key
 --------- | ------------
Generate database | `,u`
add database under the cur dir | `,a`,split view:`<C-\>a`
GotoDefinition  under the cursor | `,g`,split view:`<C-\>g`
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

# Awesome colorscheme

[sjl/badwolf](https://github.com/sjl/badwolf)

[altercation/vim-colors-solarized](https://github.com/altercation/vim-colors-solarized)

[tomasr/molokai](https://github.com/tomasr/molokai)

[morhetz/gruvbox](https://github.com/morhetz/gruvbox)

[NLKNguyen/papercolor-theme](https://github.com/NLKNguyen/papercolor-theme) (default)

[KabbAmine/yowish.vim](https://github.com/KabbAmine/yowish.vim)

# Pluglist

[tracyone/a.vim](https://github.com/tracyone/a.vim)

[Valloric/YouCompleteMe](https://github.com/Valloric/YouCompleteMe)

[rdnetto/YCM-Generator](https://github.com/rdnetto/YCM-Generator)

[Shougo/neocomplete](https://github.com/Shougo/neocomplete)

[tracyone/dict](https://github.com/tracyone/dict)

[Konfekt/FastFold](https://github.com/Konfekt/FastFold)

[tracyone/hex2ascii.vim](https://github.com/tracyone/hex2ascii.vim)

[rking/ag.vim](https://github.com/rking/ag.vim)

[thinca/vim-qfreplace](https://github.com/thinca/vim-qfreplace)

[vim-scripts/verilog.vim](https://github.com/vim-scripts/verilog.vim)

[easymotion/vim-easymotion](https://github.com/easymotion/vim-easymotion)

[thinca/vim-quickrun](https://github.com/thinca/vim-quickrun)

[thinca/vim-fontzoom](https://github.com/thinca/vim-fontzoom)

[sjl/badwolf](https://github.com/sjl/badwolf)

[altercation/vim-colors-solarized](https://github.com/altercation/vim-colors-solarized)

[osyo-manga/vim-over](https://github.com/osyo-manga/vim-over)

[tomasr/molokai](https://github.com/tomasr/molokai)

[morhetz/gruvbox](https://github.com/morhetz/gruvbox)

[NLKNguyen/papercolor-theme](https://github.com/NLKNguyen/papercolor-theme)

[KabbAmine/yowish.vim](https://github.com/KabbAmine/yowish.vim)

[terryma/vim-multiple-cursors](https://github.com/terryma/vim-multiple-cursors)

[ashisha/image.vim](https://github.com/ashisha/image.vim)

[terryma/vim-expand-region](https://github.com/terryma/vim-expand-region)

[ctrlpvim/ctrlp.vim](https://github.com/ctrlpvim/ctrlp.vim)

[tacahiroy/ctrlp-funky](https://github.com/tacahiroy/ctrlp-funky)

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

[mhinz/vim-startify](https://github.com/mhinz/vim-startify)

[SirVer/ultisnips](https://github.com/SirVer/ultisnips)

[ianva/vim-youdao-translater](https://github.com/ianva/vim-youdao-translater)

[iamcco/markdown-preview.vim](https://github.com/iamcco/markdown-preview.vim)

[mzlogin/vim-markdown-toc](https://github.com/mzlogin/vim-markdown-toc)

[christoomey/vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator)

[lucidstack/ctrlp-tmux.vim](https://github.com/lucidstack/ctrlp-tmux.vim)

[vim-scripts/sudo.vim](https://github.com/vim-scripts/sudo.vim)

[nhooyr/neoman.vim](https://github.com/nhooyr/neoman.vim)

[tracyone/pyclewn_linux](https://github.com/tracyone/pyclewn_linux)

[CodeFalling/fcitx-vim-osx](https://github.com/CodeFalling/fcitx-vim-osx)

[CodeFalling/fcitx-vim-osx](https://github.com/CodeFalling/fcitx-vim-osx)

[Shougo/vimproc.vim](https://github.com/Shougo/vimproc.vim)

[Shougo/vimshell.vim](https://github.com/Shougo/vimshell.vim)

[vim-scripts/YankRing.vim](https://github.com/vim-scripts/YankRing.vim)

[mattn/ctrlp-register',{'on': 'CtrlPRegister'](https://github.com/mattn/ctrlp-register)

[benekastah/neomake](https://github.com/benekastah/neomake)

[vim-scripts/The-NERD-Commenter](https://github.com/vim-scripts/The-NERD-Commenter)

[scrooloose/nerdtree](https://github.com/scrooloose/nerdtree)

[kshenoy/vim-signature](https://github.com/kshenoy/vim-signature)

[tpope/vim-surround](https://github.com/tpope/vim-surround)

[majutsushi/tagbar](https://github.com/majutsushi/tagbar)

[mbbill/undotree](https://github.com/mbbill/undotree)

[vim-scripts/L9](https://github.com/vim-scripts/L9)

[mattn/emmet-vim](https://github.com/mattn/emmet-vim)

[junegunn/vim-easy-align](https://github.com/junegunn/vim-easy-align)

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


# Config Structure

![structure](https://cloud.githubusercontent.com/assets/4246425/16357646/0b8c9814-3b2f-11e6-8f21-b6247e4e6e02.png)

Open file `vimrc` with vim,it will be  folded automatically, you can press `za`(vim normal mode) to open or close fold.

- System Check:OS,vim IO,vim type check

- Basic Setting:vim basic setting like show line number,status line,backup file encode ...

- Key mapping: vim basic key mapping( exclude plugins's keymapping )

- Plugin setting:Plugins's setting

- Function:Some useful vim function

- Gui releate:gvim,macvim,font,mouse setting....

