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

## Source code reading and GoToDefinition

Function |  ShortCut Key

--------- | -------------
Generate database | <leader>u,split view:<C-\>g
add database in cur dir | <leader>a,split view:<C-\>a
GotoDefinition  on cursor | <leader>g,split view:<C-\>g
Find functions calling this function on cusor | <leader>c,split view:<C-\>c
