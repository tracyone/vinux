![screenshot](https://cloud.githubusercontent.com/assets/4246425/15250970/dae5518e-1959-11e6-8dc5-bed1c23f7a02.png)


* [安装](#安装)
* [配置结构](#配置结构)
* [按键映射和功能描述](#按键映射和功能描述)
	* [源码阅读和跳转](#源码阅读和跳转)
	* [文件Fuzzy搜索和字符串搜索](#文件fuzzy搜索和字符串搜索)
	* [功能按键](#功能按键)
	* [GUI相关](#gui相关)
* [奇技淫巧](#奇技淫巧)
	* [多光标编辑](#多光标编辑)
	* [快速移动](#快速移动)
	* [代码片段](#代码片段)
	* [查看图片(ASCII形式)](#查看图片ascii形式)
	* [Markdown预览](#markdown预览)

#  安装

English guide see [readme_en.md](./readme_en.md)

确保你安装好`git`和`curl`，并确保它们可以在你系统的PATH变量中找到。

执行以下脚本，然后启动vim，确保你的电脑是可以联网的，耐心等待所有东西就会自行安装好。

```bash
./install.sh
```

# 配置结构

![structure](https://cloud.githubusercontent.com/assets/4246425/16357646/0b8c9814-3b2f-11e6-8f21-b6247e4e6e02.png)

用vim打开`vimrc`文件,你将会看到大部分内容被自动折叠起来，你可以使用`za`快捷键来打开或者关闭折叠。

- System Check:系统检测，vim支持的IO情况等。

- Basic Setting:vim最基本的设定

- Key mapping: vim基本的按键映射（不包括插件的按键映射）

- Plugin setting:所有插件的设置

- Function:自定义的viml函数

- Gui releate:gvim，macvim等图形界面的设置。

# 按键映射和功能描述

在**t-vim**中的`<leader>`表示逗号`,`。

normal模式下按`<leader>vc`即可编辑vimrc文件，编辑好之后按`<leader>so`即可让vimrc生效。

## 源码阅读和跳转

功能 | 模式 | 快捷键
--------- | ---------- | ---------------
生成数据库 | normal | `<leader>u`
添加当前路径下的数据库 | normal | `<leader>a`,split view:`<C-\>a`
跳转到当前光标下的定义  | normal | `<leader>g`,split view:`<C-\>g`
跳转下当前光标下函数的调用者 | normal | `<leader>c`,split view:`<C-\>c`

**t-vim** 在每次打开vim时会自动添加当前路径下的cscope数据库

**t-vim** 还可以根据当前路径下的`.project`文件添加不同路径下的cscope数据库。

文件 `.project` 的格式是：

```
/home/tracyone/work/ctest/
/usr/inculde/
```

如果文件`.project` 在当前路径存在的话，那么当你按下`<leader>u`的时候，**t-vim**将会询问是否为`.project`中指定路径生成对应的cscope数据库。

当按下`<leader>g`，**t-vim**将会尝试使用YouCompleteMe的GoToDefinition功能，如果失败才会使用cscope的跳转功能。

## 文件Fuzzy搜索和字符串搜索

[ctrlpvim](https://github.com/ctrlpvim/ctrlp.vim)

[ctrlp-funky](https://github.com/tacahiroy/ctrlp-funky)

[ag.vim](https://github.com/rking/ag.vim)

快捷键 | 模式 | 功能 
--------- | ---------- | ---------------
 `Ctrl-p` | normal  | fuzzy 搜索文件
 `Ctrl-k` | normal  | fuzzy 搜索当前文件的函数
 `Ctrl-j` | normal  | fuzzy 搜索buffers
 `Ctrl-l` | normal  | fuzzy 搜索最近打开的文件
 `<leader>vv` | normal,visual | 全局搜索当前光标下的字符串
 `<leader>vf` | normal | global 全局搜索当前光标下的C函数
 `<leader>vt` | normal | 全局搜索**TODO**或者**FIXME**

 为了加快搜索速度，非常推荐你安装[the silver searcher](https://github.com/ggreer/the_silver_searcher)。


## 功能按键

快捷键 | 模式 | 功能
--------- | ---------- | ---------------
`F1` | all | 打开帮助
`F2` | all | 打开重命名窗口，使用的是 [renamer.vim](https://github.com/vim-scripts/renamer.vim)
`F3` | all | 打开Gstatus窗口，使用的是[tpope/vim-fugitive](https://github.com/tpope/vim-fugitive)
`F4` | all | 打开shell，使用的是[vimshell.vim](https://github.com/Shougo/vimshell.vim)，如果使用[neovim](https://github.com/neovim/neovim)就使用自带终端模拟器
`F5` | all | 执行Make并打开quickfix窗口，如果使用 [neovim](https://github.com/neovim/neovim)的话就使用[neomake](https://github.com/benekastah/neomake) 
`F6` | normal,visual | 快速运行当前脚本文件，使用的是[quckrun](https://github.com/thinca/vim-quickrun)
`F7` | normal | 为当前打开的文件执行dos2unix或者unix2dos
`F8` | all | 保存当前session，使用的插件是[mhinz/vim-startify](https://github.com/mhinz/vim-startify)
`F9` | normal | 打开tagbar窗口，使用的是[tagbar](https://github.com/majutsushi/tagbar)
`F10` | normal,visual | 翻译当前光标下的单词使用的是[vim-youdao-translater](https://github.com/ianva/vim-youdao-translater)
`F11` | normal | 打开文件管理器，使用的是[VimExplorer](https://github.com/mbbill/VimExplorer)
`F12` | normal,insert | 打开只读的文件管理器使用的是[nerdtree](https://github.com/scrooloose/nerdtree)

## GUI相关

在MacVim和gVim的情况下，你可以做以下调整：

快捷键 | 模式 | 功能
--------- | ---------- | ---------------
`Alt+=` | normal | 放大字体
`Alt+-` | normal | 缩小字体
`Alt-o` | normal | 恢复默认配置的字体大小
`Ctrl+F8` | normal | 菜单和工具栏显示或者隐藏（toggle）

本配置主题有：

- [sjl/badwolf](https://github.com/sjl/badwolf)
- [altercation/vim-colors-solarized](https://github.com/altercation/vim-colors-solarized)
- [tomasr/molokai](https://github.com/tomasr/molokai)
- [morhetz/gruvbox](https://github.com/morhetz/gruvbox)
- [NLKNguyen/papercolor-theme](https://github.com/NLKNguyen/papercolor-theme)
- [KabbAmine/yowish.vim](https://github.com/KabbAmine/yowish.vim)

修改字体大小或者字体类型主题类型之后，你只需要执行`:Love`就能保存你的配置了。

# 奇技淫巧

## 多光标编辑

[terryma/vim-multiple-cursors](https://github.com/terryma/vim-multiple-cursors)

快捷键 | 模式 | 功能
--------- | ---------- | ---------------
`Ctrl-n` | normal,visual | 同时编辑

## 快速移动

[easymotion/vim-easymotion](https://github.com/easymotion/vim-easymotion)

快捷键 | 模式 | 功能
--------- | ---------- | ---------------
`W` | normal | 你懂的，按下你就知道
`B` | normal | 你懂的，按下你就知道

## 代码片段

[SirVer/ultisnips](https://github.com/SirVer/ultisnips)

快捷键 | 模式 | 功能
--------- | ---------- | ---------------
`Cltrl-j` | insert | 触发snippets的扩展和跳到下一个编辑区，YCM支持ultisnips的补全，在补全窗口中标有snip的就是。
`Cltrl-k` | insert | 跳到上一个编辑区

## 查看图片(ASCII形式)

[ashisha/image.vim](https://github.com/ashisha/image.vim)

直接用vim打开jpg文件就行。

## Markdown预览

在编辑markdown文件的时候执行`:MarkdownPreview`就能调用浏览器实时预览markdown效果。

执行`:GenTocGFM`就可以为当前编辑的markdown文件生成目录代码。
