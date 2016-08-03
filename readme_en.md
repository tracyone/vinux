![screenshot](https://cloud.githubusercontent.com/assets/4246425/15250970/dae5518e-1959-11e6-8dc5-bed1c23f7a02.png)

#  Installation

Make sure you have installed git and curl command.

Execute following shell script then start vim,it will install all stuff automatically.

```bash
./install.sh
```

# Config Structure

![structure](https://cloud.githubusercontent.com/assets/4246425/16357646/0b8c9814-3b2f-11e6-8f21-b6247e4e6e02.png)

Open file `vimrc` with vim,it will be  folded automatically, you can press `za`(vim normal mode) to open or close fold.

- System Check:OS,vim IO,vim type check

- Basic Setting:vim basic setting like show line number,status line,backup file encode ...

- Key mapping: vim basic key mapping( exclude plugins's keymapping )

- Plugin setting:Plugins's setting

- Function:Some useful vim function

- Gui releate:gvim,macvim,font,mouse setting....

# Key mapping and Functions description.

`<leader>` in **t-vim** is comma : `,`. 

`<leader>vc`:edit vimrc，
`<leader>so`:source vimrc

## Source code reading and GoToDefinition

Function |  ShortCut Key
 --------- | ------------
Generate database | `<leader>u`
add database under the cur dir | `<leader>a`,split view:`<C-\>a`
GotoDefinition  under the cursor | `<leader>g`,split view:`<C-\>g`
Find functions calling this function under the cursor | `<leader>c`,split view:`<C-\>c`

**t-vim** will automatically add cscope.out under the current directory.

**t-vim** will add all cscope.out which path is specified by file `.project` under the current directory.

File `.project` format:

```
/home/tracyone/work/ctest/
/usr/inculde/
```

if file `.project` is exist at the current directory,when press `<leader>u` **t-vim** will ask whether Generate database for specified path in `.project`.

When press `<leader>g`,**t-vim** will try to use the function of YouCompleteMe GoToDefinition,if it failed,then use cscope.

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


## FunctionKey

Function | mode | ShortCut Key
--------- | ---------- | ---------------
`F1` | all | Open vim help
`F2` | all | Open rename windows,use [renamer.vim](https://github.com/vim-scripts/renamer.vim)
`F3` | all | Open Gstatus windows ,use [tpope/vim-fugitive](https://github.com/tpope/vim-fugitive)
`F4` | all | Open shell,use [vimshell.vim](https://github.com/Shougo/vimshell.vim)，or terminal emulator in [neovim](https://github.com/neovim/neovim)
`F5` | all | Execute make then open quickfix,use [neomake](https://github.com/benekastah/neomake) when use [neovim](https://github.com/neovim/neovim)
`F6` | normal,visual | execute current script [quckrun](https://github.com/thinca/vim-quickrun)
`F7` | normal | perform dos2unix or unix2dos for current open file.
`F8` | all | save current session ,use [mhinz/vim-startify](https://github.com/mhinz/vim-startify)
`F9` | normal | open tagbar windows,use [tagbar](https://github.com/majutsushi/tagbar)
`F10` | normal,visual | YouDao dict translate the word under the cursor,use  [vim-youdao-translater](https://github.com/ianva/vim-youdao-translater)
`F11` | normal | Open vim file manager,use [VimExplorer](https://github.com/mbbill/VimExplorer)
`F12` | normal,insert | open nerdtree,use [nerdtree](https://github.com/scrooloose/nerdtree)
