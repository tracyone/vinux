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

function! te#feat#get_var_value(A, L, P) abort
    let l:result=''
    for l:needle in s:var_candidate
        let l:result.=l:needle.nr2char(10)
    endfor
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
    let l:vinux_version=te#compatiable#systemlist('git describe')
    if type(l:vinux_version) == g:t_number
        call te#utils#EchoWarning("git describe fail", 'err')
        return ''
    endif
    let l:temp2=te#feat#get_vim_version()
    if v:shell_error != 0
	    let g:vinux_version='vinux V1.3.3'.' @'.l:temp2[0].'.'.l:temp2[1]
    else
        let l:temp = matchstr(l:vinux_version[-1],'.*\(-\d\+-\w\+\)\@=')
        if  l:temp !=# ''
            let l:vinux_version[-1]=l:temp.'-dev'
        endif
        let g:vinux_version='vinux '.l:vinux_version[-1].' @'.l:temp2[0].'.'.l:temp2[1]
    endif
    let g:vinux_version=string(g:vinux_version)
    call te#compatiable#writefile(['let g:vinux_version='.g:vinux_version], $VIMFILES.'/feature.vim', 'a')
    call te#utils#EchoWarning('Updated feature.vim successfully!', 'warn', 1)
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

function! te#feat#feat_dyn_enable(en) abort
    if a:en == 1
        let l:enable='Enable'
    else
        let l:enable='Disable'
    endif
    let l:feat = input(l:enable.' the feature(or "all"): ','g:feat_enable_','custom,te#feat#get_feature')
    if l:feat !=# 'all'
        if !has_key(s:feature_dict, l:feat)
            call te#utils#EchoWarning(l:feat.' feature is not exist!', 'err')
            return
        endif
        if type(eval(l:feat))
            let s:var_candidate=[]
            let l:feat_candidate=eval(matchstr(l:feat,'.*\(\.cur_val\)\@=').'.candidate')
            call extend(s:var_candidate,l:feat_candidate)
            let l:str=input('Input the value of '.l:feat.': ', '', 'custom,te#feat#get_var_value')
            let s:feature_dict[l:feat]=string(l:str)
            execute 'let '.l:feat.'='.string(l:str)
            call te#feat#gen_feature_vim(0)
            call te#utils#EchoWarning('Set '.l:feat.' to '.string(l:str).' successfully!')
            return
        else
            let s:feature_dict[l:feat]=a:en
            execute 'let '.l:feat.'='.a:en
            call te#feat#gen_feature_vim(0)
            call te#feat#feat_enable(l:feat,eval(s:feature_dict[l:feat]))
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
    call te#utils#EchoWarning(l:enable.' '.l:feat.' successfully!')
endfunction

function! te#feat#source_rc(path, ...) abort
  let l:use_global = get(a:000, 0, !has('vim_starting'))
  let l:abspath = resolve(expand($VIMFILES.'/rc/' . a:path))
  if !l:use_global
    execute 'source' fnameescape(l:abspath)
    return
  endif

  " substitute all 'set' to 'setglobal'
  let l:content = map(readfile(l:abspath),
        \ 'substitute(v:val, "^\\W*\\zsset\\ze\\W", "setglobal", "")')
  " create l:tempfile and source the l:tempfile
  let l:tempfile = tempname()
  try
    call te#compatiable#writefile(l:content, l:tempfile)
    execute 'source' fnameescape(l:tempfile)
  finally
    if filereadable(l:tempfile)
      call delete(l:tempfile)
    endif
  endtry
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
endfunction

function! te#feat#init_var(val, default)
    execute 'let '.a:val.'={}'
    execute 'let '.a:val.'.cur_val='.string(a:default[0])
    execute 'let '.a:val.'.candidate=[]'
    execute 'call extend('.a:val.'.candidate'.',a:default'.')'
    let s:feature_dict[a:val.'.cur_val']=string(a:default[0])
endfunction

let s:plugin_func_list=[]

if te#env#SupportTimer()
    let s:vim_enter_timer=timer_start(500, function('te#feat#run_vim_enter_setting'), {'repeat': 1})
endif
"funcref must be a funcref variable
function! te#feat#register_vim_enter_setting(funcref) abort
    call add(s:plugin_func_list, a:funcref)
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
        silent! call l:Needle()
        if type(l:Needle) == g:t_func
            silent! call l:Needle()
        elseif type(l:Needle) == g:t_string
            silent! execute l:Needle
        endif
        unlet l:Needle
    endfor
    for l:Needle in s:plugin_func_list
        silent! call l:Needle()
    endfor
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
                \ 'asyncomplete.vim', 'deoplete.nvim','ncm2', 'supertab', 'nvim-cmp'])
    call te#feat#init_var('g:fuzzysearcher_plugin_name', ['ctrlp', 'leaderf', 'denite.nvim', 'fzf', 'vim-clap'])
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
    call te#feat#init_var('g:vinux_coding_style', ['linux', 'mozilla', 'google', 'llvm'])
    call te#feat#init_var('g:enable_sexy_mode', ['off', 'on'])
    call te#feat#init_var('g:tagging_program', ['cscope', 'gtags'])
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
    "gtags
    let $GTAGSLABEL = 'ctags-exuberant'

endfunction
