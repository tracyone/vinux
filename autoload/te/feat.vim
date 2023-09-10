let s:feature_dict={}
"return vim version infomatrion
"l:result[0]:vim main version
"l:result[1]:vim patch info
function! te#feat#get_vim_version() abort
    let l:result=[]
    if te#env#IsNvim() != 0
        let v = api_info().version
        call add(l:result,'nvim')
        call add(l:result,printf('%d.%d.%d', v.major, v.minor, v.patch))
    else
        redir => l:msg
        silent! execute ':version'
        redir END
        call add(l:result,matchstr(l:msg,'VIM - Vi IMproved\s\zs\d.\d\ze'))
        call add(l:result, matchstr(l:msg, ':\s\d-\zs\d\{1,4\}\ze'))
    endif
    return l:result
endfunction

function! te#feat#get_feature(A, L, P) abort
    let l:temp=a:A.a:L.a:P
    if !exists('s:feature_dict')
        return 'GET FEATURE ERROR'
    endif
    let l:result=l:temp 
    let l:result=''
    for l:key in keys(s:feature_dict)
        let l:result.=l:key."\n"
    endfor
    let l:result.='all'."\n"
    return l:result
endfunction

function! te#feat#gen_feature_vim(reset) abort
    execute 'cd '.$VIMFILES
    call delete($VIMFILES.'/feature.vim')
    if a:reset == 1 
        call te#utils#EchoWarning('Reseted feature.vim successfully! Please restart vim!')
        return 
    endif
	for l:key in keys(s:feature_dict)
	   call te#compatiable#writefile(['let '.l:key.'='.s:feature_dict[l:key]], $VIMFILES.'/feature.vim', 'a')
	endfor
    let l:temp2=te#feat#get_vim_version()
    let l:vinux_version=te#compatiable#systemlist('git describe')
    if type(l:vinux_version) == g:t_number || v:shell_error != 0
        let g:vinux_version='vinux V1.8.0'.' @'.l:temp2[0].'.'.l:temp2[1]
    else
        let l:temp = matchstr(l:vinux_version[-1],'.*\(-\d\+-\w\+\)\@=')
        if  l:temp !=# ''
            let l:vinux_version[-1]=l:temp.'-dev'
        endif
        let g:vinux_version='vinux '.l:vinux_version[-1].' @'.l:temp2[0].'.'.l:temp2[1]
    endif
    let g:vinux_version=string(g:vinux_version)
    call te#compatiable#writefile(['let g:vinux_version='.g:vinux_version], $VIMFILES.'/feature.vim', 'a')
    call te#utils#EchoWarning('Updated feature.vim successfully!', 'warn')
endfunction

function! te#feat#gen_local_vim() abort
    call te#compatiable#writefile(['function! TVIM_pre_init()'], $VIMFILES.'/local.vim')
    call te#compatiable#writefile(['endfunction'], $VIMFILES.'/local.vim', 'a')
    call te#compatiable#writefile(['function! TVIM_user_init()'], $VIMFILES.'/local.vim', 'a')
    call te#compatiable#writefile(['endfunction'], $VIMFILES.'/local.vim', 'a')
    call te#compatiable#writefile(['function! TVIM_plug_init()'], $VIMFILES.'/local.vim', 'a')
    call te#compatiable#writefile(['endfunction'], $VIMFILES.'/local.vim', 'a')
endfunction

function! te#feat#get_feature_dict() abort
    return s:feature_dict
endfunction

function! s:get_var_value(feat, result) abort
    let l:str = s:var_candidate[a:result - 1]
    let s:feature_dict[a:feat]=string(l:str)
    execute 'let '.a:feat.'='.string(l:str)
    call te#feat#gen_feature_vim(0)
    call te#utils#EchoWarning('Set '.a:feat.' to '.string(l:str).' successfully!', 'info')
endfunction

function! te#feat#feature_enable(en, feat) abort
    if a:en == 1
        let l:enable='Enable'
    else
        let l:enable='Disable'
    endif
    if a:feat !=# 'all'
        if !has_key(s:feature_dict, a:feat)
            call te#utils#EchoWarning(a:feat.' feature is not exist!', 'err')
            return
        endif
        if type(eval(a:feat))
            let s:var_candidate=[]
            let l:feat_candidate=eval(matchstr(a:feat,'.*\(\.cur_val\)\@=').'.candidate')
            call extend(s:var_candidate, l:feat_candidate)
            call te#utils#confirm('Select '.a:feat."'s option", s:var_candidate, {'func':function('<SID>get_var_value'), 'arg':[a:feat]})
            return
        else
            let s:feature_dict[a:feat]=a:en
            execute 'let '.a:feat.'='.a:en
            call te#feat#gen_feature_vim(0)
            call te#feat#feat_enable(a:feat,eval(s:feature_dict[a:feat]))
        endif
    else
        for l:key in keys(s:feature_dict)
            if type(eval(l:key)) != g:t_string
                let s:feature_dict[l:key]=a:en
                execute 'let '.l:key.'='.a:en
                call te#feat#feat_enable(l:key,eval(s:feature_dict[l:key]))
            endif
        endfor
        call te#feat#gen_feature_vim(0)
    endif
    if a:en == 1 | :PlugInstall --sync | q | endif
    call te#feat#source_rc('colors.vim')
    call te#utils#EchoWarning(l:enable.' '.a:feat.' successfully!', 'info')
endfunction

function! te#feat#feat_dyn_enable(en) abort
    if a:en == 1
        let l:enable='Enable'
    else
        let l:enable='Disable'
    endif
    let l:feat = input(l:enable.' the feature(or "all"): ','g:feat_enable_','custom,te#feat#get_feature')
    call te#feat#feature_enable(a:en, l:feat)
endfunction

"source file frome rc folder
function! te#feat#source_rc(path) abort
    execute 'source '.$VIMFILES.'/rc/'.a:path
endfunction

function! te#feat#feat_enable(var, default) abort
    if !exists(a:var)
        let l:val=a:default
    else
        let l:val=eval(a:var)
    endif
    execute 'let '.a:var.'='.l:val
    let s:feature_dict[a:var]=l:val
    if !exists(':Plug')
        return
    endif
    if eval(a:var) != 0 && matchstr(a:var, 'g:feat_enable_') !=# ''
        call te#feat#source_rc(matchstr(a:var,'_\zs[^_]*\ze$').'.vim')
    endif
    call te#feat#source_rc('colors.vim')
endfunction

function! te#feat#init_var(val, default)
    execute 'let '.a:val.'={}'
    execute 'let '.a:val.'.cur_val='.string(a:default[0])
    execute 'let '.a:val.'.candidate=[]'
    execute 'call extend('.a:val.'.candidate'.',a:default'.')'
    let s:feature_dict[a:val.'.cur_val']=string(a:default[0])
endfunction

if te#env#SupportTimer()
    let s:vim_enter_timer=timer_start(300, function('te#feat#run_vim_enter_setting'), {'repeat': 1})
endif
"funcref must be a funcref variable
function! te#feat#register_vim_enter_setting(funcref) abort
    call add(s:plugin_func_list_vim_enter, a:funcref)
endfunction

let s:pluin_list_load_vim_enter = []
let s:plugin_func_list_vim_enter = []
function! te#feat#register_vim_enter_setting2(funcref, plug_name) abort
    call extend(s:pluin_list_load_vim_enter, a:plug_name)
    call extend(s:plugin_func_list_vim_enter, a:funcref)
endfunction

function! te#feat#run_vim_enter_setting(timer) abort
    call plug#load(s:pluin_list_load_vim_enter)
    for l:Needle in s:plugin_func_list_vim_enter
        if type(l:Needle) == g:t_func
            silent! call l:Needle()
        elseif type(l:Needle) == g:t_string
            silent! execute l:Needle
        endif
        unlet l:Needle
    endfor
    call te#utils#EchoWarning("Load plugins finish ...", 'info')
endfunction

let s:pluin_list_load_after_insert = []
let s:plugin_func_list_load_after_insert = []
"argument funcref can be a Funcref variable or a command
"plug_name must be a list
function! te#feat#register_vim_plug_insert_setting(funcref, plug_name) abort
    call extend(s:pluin_list_load_after_insert, a:plug_name)
    call extend(s:plugin_func_list_load_after_insert, a:funcref)
endfunction

function! te#feat#vim_plug_insert_enter() abort
    call plug#load(s:pluin_list_load_after_insert)
    for l:Needle in s:plugin_func_list_load_after_insert
        if type(l:Needle) == g:t_func
            call l:Needle()
        else
            execute l:Needle
        endif
        unlet l:Needle
    endfor
endfunction

function! te#feat#check_plugin_install() abort
    if g:enable_auto_plugin_install.cur_val ==# 'off'
        return
    endif
    if !exists(':Plug')
        return
    endif
    if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
        call te#utils#EchoWarning('Install the missing plugins!')
        PlugInstall --sync | q
        call te#feat#source_rc('colors.vim')
    endif
endfunction

"open vim config and change directory.
function te#feat#edit_config() abort
    if te#utils#is_listed_buffer()
        :tabedit $MYVIMRC
    else
        :e $MYVIMRC
    endif
    execute 'vsplit '.fnamemodify($MYVIMRC, ":p:h").'/feature.vim'
    execute 'split '.fnamemodify($MYVIMRC, ":p:h").'/local.vim'
    call te#utils#goto_cur_file(2)
endfunction

"init all vinux custom variable
function! te#feat#init_all() abort

    call te#feat#init_var('g:fuzzy_matcher_type',['py-matcher', 'cpsm'])
    call te#feat#init_var('g:complete_plugin_type',['YouCompleteMe', 'clang_complete', 'neocomplete',
                \ 'asyncomplete.vim', 'deoplete.nvim','ncm2', 'supertab', 'nvim-cmp', 'coc.nvim'])
    call te#feat#init_var('g:fuzzysearcher_plugin_name', ['ctrlp', 'leaderf', 'denite.nvim', 'fzf', 'vim-clap', 'telescope.nvim'])
    call te#feat#init_var('g:git_plugin_name',['vim-fugitive','gina.vim'])
    call te#feat#init_var('g:enable_powerline_fonts', ['off','on'])
    call te#feat#init_var('g:enable_auto_plugin_install', ['on','off'])
    call te#feat#init_var('g:vinux_plugin_dir', [$VIMFILES.'/bundle/', $HOME.'/plugged/'])
    "note this value will be override if not support this plugin
    call te#feat#init_var('g:grepper_plugin', ["neomake-multiprocess", "vim-easygrep"])
    "off:no use cache when using ctrlp
    "on: always use cache when using ctrlp
    "limit:use cache when exceed the limit files
    call te#feat#init_var('g:ctrlp_caching_type', ['limit', 'on', 'off'])
    "c & cpp coding style
    call te#feat#init_var('g:vinux_coding_style', ['linux', 'mozilla', 'google', 'llvm', 'chromium'])
    call te#feat#init_var('g:enable_sexy_mode', ['off', 'on'])
    call te#feat#init_var('g:tagging_program', ['cscope', 'gtags'])
    call te#feat#init_var('g:message_delay_time', ['5000', '3000', '1000', '500'])
    call te#feat#init_var('g:file_explorer_plugin', ['nerdtree', 'defx.nvim', 'coc-explorer'])
    if filereadable($VIMFILES.'/feature.vim')
        try
            execute ':source '.$VIMFILES.'/feature.vim'
        catch /^Vim\%((\a\+)\)\=:E/	
            call delete($VIMFILES.'/feature.vim')
        endtry
    endif

    "update feature dict
    for l:key in keys(s:feature_dict)
        if type(l:key)
            let s:feature_dict[l:key]=string(eval(l:key))
        endif
    endfor

endfunction
