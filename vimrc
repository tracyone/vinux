"File       vimrc 
"Brief      config file for neovim,vim,gvim in linux,gvim in win32,macvim
"Date       2015-11-28/22:56:20
"Author     tracyone,tracyone@live.cn,
"Github     https://github.com/tracyone/t-vim
"Website    http://onetracy.com
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set nocompatible

if te#env#IsWindows()
    let $VIMFILES = $HOME.'/vimfiles'
else
    let $VIMFILES = $HOME.'/.vim'
endif
let $PATH = $VIMFILES.'/bin:'.$PATH

if filereadable($VIMFILES.'/feature.vim')
    execute ':source '.$VIMFILES.'/feature.vim'
endif

call te#feat#source_rc('autocmd.vim')
call te#feat#source_rc('options.vim')
call te#feat#source_rc('mappings.vim')


"user custom config file
if filereadable($VIMFILES.'/local.vim')
    execute ':source '.$VIMFILES.'/local.vim'
else
    call te#feat#gen_local_vim()
endif

if exists('*TVIM_pre_init')
    call TVIM_pre_init()
endif

if exists('g:t_vim_plugin_install_path')
    if type(g:t_vim_plugin_install_path) ==# g:t_string
        if !isdirectory(g:t_vim_plugin_install_path)
            silent! call mkdir(g:t_vim_plugin_install_path, 'p')
            if !isdirectory(g:t_vim_plugin_install_path)
                call te#utils#EchoWarning('Create '.g:t_vim_plugin_install_path.' fail!', 'err', 1)
                let g:t_vim_plugin_install_path=$VIMFILES.'/bundle/'
            endif
        endif
    else
        call te#utils#EchoWarning('g:t_vim_plugin_install_path must be a string !', 'err', 1)
        let g:t_vim_plugin_install_path=$VIMFILES.'/bundle/'
    endif
else
    let g:t_vim_plugin_install_path=$VIMFILES.'/bundle/'
endif

let &rtp=&rtp.','.$VIMFILES
if empty(glob($VIMFILES.'/autoload/plug.vim'))
    if te#env#Executable('curl') && te#env#Executable('git')
        if te#env#IsWindows()
            silent! exec ':!mkdir -p '.$VIMFILES.'\\autoload'
            silent! exec ':!curl -fLo ' . $VIMFILES.'\\autoload'.'\\plug.vim ' .
                        \ 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
        else
            silent! exec ':!mkdir -p '.$VIMFILES.'/autoload'
            silent! exec ':!curl -fLo ' . $VIMFILES.'/autoload'.'/plug.vim ' .
                        \ 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
        endif
    else
        call te#utils#EchoWarning('Please install curl and git!', 1)
    endif
endif
silent! call plug#begin(g:t_vim_plugin_install_path)

call te#feat#feat_enable('g:complete_plugin_type','ycm')
call te#feat#feat_enable('g:fuzzysearcher_plugin_name', 'ctrlp')
call te#feat#feat_enable('g:git_plugin_name','vim-fugitive')
call te#feat#feat_enable('g:feat_enable_complete', 0)
call te#feat#feat_enable('g:feat_enable_jump', 1)
call te#feat#feat_enable('g:feat_enable_tmux', 0)
call te#feat#feat_enable('g:feat_enable_git', 0)
call te#feat#feat_enable('g:feat_enable_c', 0)
call te#feat#feat_enable('g:feat_enable_markdown', 0)
call te#feat#feat_enable('g:feat_enable_vim', 0)
call te#feat#feat_enable('g:airline_powerline_fonts', 0)
call te#feat#feat_enable('g:feat_enable_gui', 1)
call te#feat#feat_enable('g:feat_enable_tools', 0)
call te#feat#feat_enable('g:feat_enable_edit', 0)
call te#feat#feat_enable('g:feat_enable_frontend', 0)
call te#feat#feat_enable('g:feat_enable_help', 0)
call te#feat#feat_enable('g:feat_enable_basic', 1)
call te#feat#feat_enable('g:feat_enable_airline', 0)
call te#feat#feat_enable('g:feat_enable_writing', 0)
call te#feat#feat_enable('g:feat_enable_zsh', 0)
call te#feat#feat_enable('g:feat_enable_fun', 0)
call te#feat#feat_enable('g:enable_auto_plugin_install', 1)
call te#feat#register_vim_enter_setting(function('te#feat#check_plugin_install'))
call te#feat#register_vim_enter_setting(function('te#utils#echo_info_after'))

if !filereadable($VIMFILES.'/feature.vim')
    call te#feat#gen_feature_vim()
endif

if exists('*TVIM_plug_init')
    call TVIM_plug_init()
endif

" Open plug status windows
nnoremap <Leader>ap :PlugStatus<cr>:only<cr>
" update plugin
nnoremap <Leader>au :PlugUpdate<cr>
silent! call plug#end()

colorscheme desert "default setting 

if exists('*TVIM_user_init')
    call TVIM_user_init()
endif

filetype plugin indent on
syntax on
set modeline
