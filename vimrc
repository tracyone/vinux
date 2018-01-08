"File       vimrc 
"Brief      config file for neovim,vim,gvim in linux,gvim in win32,macvim
"Date       2015-11-28/22:56:20
"Author     tracyone,tracyone@live.cn,
"Github     https://github.com/tracyone/vinux
"Website    http://onetracy.com
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

call te#feat#init_all()
call te#feat#source_rc('autocmd.vim')
call te#feat#source_rc('options.vim')
call te#feat#source_rc('mappings.vim')

"user custom config file
if filereadable($VIMFILES.'/local.vim')
    try
        execute ':source '.$VIMFILES.'/local.vim'
    catch /^Vim\%((\a\+)\)\=:E/	
        call te#feat#gen_local_vim()
    endtry
else
    call te#feat#gen_local_vim()
endif

if exists('*TVIM_pre_init')
    call TVIM_pre_init()
endif

if !isdirectory(g:vinux_plugin_dir.cur_val)
    silent! call mkdir(g:vinux_plugin_dir.cur_val, 'p')
    if !isdirectory(g:vinux_plugin_dir.cur_val)
        call te#utils#EchoWarning('Create '.g:vinux_plugin_dir.cur_val.' fail!', 'err', 1)
        let g:vinux_plugin_dir.cur_val=$VIMFILES.'/bundle/'
    endif
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
silent! call plug#begin(g:vinux_plugin_dir.cur_val)

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
call te#feat#feat_enable('g:feat_enable_help', 0)
call te#feat#feat_enable('g:feat_enable_basic', 1)
call te#feat#feat_enable('g:feat_enable_airline', 0)
call te#feat#feat_enable('g:feat_enable_writing', 0)
call te#feat#feat_enable('g:feat_enable_zsh', 0)
call te#feat#feat_enable('g:feat_enable_fun', 0)
call te#feat#register_vim_enter_setting(function('te#feat#check_plugin_install'))
call te#feat#register_vim_enter_setting(function('te#utils#echo_info_after'))

if !filereadable($VIMFILES.'/feature.vim')
    call te#feat#gen_feature_vim(0)
endif

if exists('*TVIM_plug_init')
    call TVIM_plug_init()
endif

silent! call plug#end()

colorscheme desert "default setting 

if exists('*TVIM_user_init')
    call TVIM_user_init()
endif

filetype plugin indent on
syntax on
set modeline
