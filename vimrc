"File       vimrc 
"Brief      config file for neovim,vim,gvim in linux,gvim in win32,macvim
"Date       2015-11-28/22:56:20
"Author     tracyone,tracyone@live.cn,
"Github     https://github.com/tracyone/t-vim
"Website    http://onetracy.com
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if &compatible
  set nocompatible
endif

if te#env#IsWindows()
    let $HOME=$VIM
    let $VIMFILES = $VIM.'/vimfiles'
else
    let $VIMFILES = $HOME.'/.vim'
endif

let g:feature_dict={}

call te#feat#source_rc('autocmd.vim')
call te#feat#source_rc('options.vim')
call te#feat#source_rc('mappings.vim')

if filereadable($VIMFILES.'/feature.vim')
    execute ':source '.$VIMFILES.'/feature.vim'
endif

let &rtp=&rtp.','.$VIMFILES
if empty(glob($VIMFILES.'/autoload/plug.vim'))
    if te#env#IsWindows()
        silent! exec ':!mkdir -p '.$VIMFILES.'\\autoload'
        silent! exec ':!curl -fLo ' . $VIMFILES.'\\autoload'.'\\plug.vim ' .
                    \ 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    else
        silent! exec ':!mkdir -p '.$VIMFILES.'/autoload'
        silent! exec ':!curl -fLo ' . $VIMFILES.'/autoload'.'/plug.vim ' .
                    \ 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    endif
endif
call plug#begin($VIMFILES.'/bundle')

call te#feat#feat_enable('g:complete_plugin_type','ycm')
call te#feat#feat_enable('g:feat_enable_complete', 0)
call te#feat#feat_enable('g:feat_enable_jump', 1)
call te#feat#feat_enable('g:feat_enable_tmux', 0)
call te#feat#feat_enable('g:feat_enable_git', 0)
call te#feat#feat_enable('g:feat_enable_c', 0)
call te#feat#feat_enable('g:feat_enable_markdown', 0)
call te#feat#feat_enable('g:feat_enable_vim', 0)
call te#feat#feat_enable('g:feat_enable_gui', 1)
call te#feat#feat_enable('g:feat_enable_tools', 0)
call te#feat#feat_enable('g:feat_enable_edit', 0)
call te#feat#feat_enable('g:feat_enable_frontend', 0)
call te#feat#feat_enable('g:feat_enable_basic', 1)
call te#feat#feat_enable('g:feat_enable_help', 0)
call te#feat#feat_enable('g:feat_enable_airline', 0)
call te#feat#feat_enable('g:airline_powerline_fonts', 0)
call te#feat#register_vim_enter_setting(function('te#feat#check_plugin_install'))

if !filereadable($VIMFILES.'/feature.vim')
    call te#feat#gen_feature_vim()
endif

" Open plug status windows
nnoremap <Leader>ap :PlugStatus<cr>:only<cr>
call plug#end()

filetype plugin indent on
syntax on
set modeline
