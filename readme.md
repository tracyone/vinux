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

When press `<leader>g`,**t-vim** will try to use YouCompleteMe's the function of GoToDefinition,if it failed,then use cscope.
