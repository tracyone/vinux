let s:feature_dict={}
"return vim version infomatrion
"l:result[0]:vim main version
"l:result[1]:vim patch info
function! te#feat#get_vim_version() abort
    redir => l:msg
    silent! execute ':version'
    redir END
    let l:result=[]
    if te#env#IsNvim()
        call add(l:result,'nvim')
        call add(l:result,matchstr(l:msg,'NVIM\s\zs\S\+\ze-'))
    else
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

function! te#feat#gen_feature_vim() abort
    execute 'cd '.$VIMFILES
    call delete($VIMFILES.'/feature.vim')
	for l:key in keys(s:feature_dict)
	   call te#feat#writefile(['let '.l:key.'='.s:feature_dict[l:key]], $VIMFILES.'/feature.vim', 'a')
	endfor
    let l:t_vim_version=system('git describe')
    let l:temp=te#feat#get_vim_version()
    if v:shell_error != 0
	    let l:t_vim_version='V0.3.3'.'@'.l:temp[0].'.'.l:temp[1].'(t-vim)'
    else
        let l:t_vim_version=split(l:t_vim_version, '\n')[-1].'@'.l:temp[0].'.'.l:temp[1].'(t-vim)'
    endif
    let g:t_vim_version=string(l:t_vim_version)
    call te#feat#writefile(['let g:t_vim_version='.string(l:t_vim_version)], $VIMFILES.'/feature.vim', 'a')
endfunction

function! te#feat#gen_local_vim() abort
    call te#feat#writefile(['function! TVIM_pre_init()'], $VIMFILES.'/local.vim')
    call te#feat#writefile(['endfunction'], $VIMFILES.'/local.vim', 'a')
    call te#feat#writefile(['function! TVIM_user_init()'], $VIMFILES.'/local.vim', 'a')
    call te#feat#writefile(['endfunction'], $VIMFILES.'/local.vim', 'a')
    call te#feat#writefile(['function! TVIM_plug_init()'], $VIMFILES.'/local.vim', 'a')
    call te#feat#writefile(['endfunction'], $VIMFILES.'/local.vim', 'a')
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
            let l:str=input('Input the value of '.l:feat.': ')
            let s:feature_dict[l:feat]=string(l:str)
            execute 'let '.l:feat.'='.string(l:str)
        else
            let s:feature_dict[l:feat]=a:en
            execute 'let '.l:feat.'='.a:en
        endif
        call te#feat#gen_feature_vim()
        call te#feat#feat_enable(l:feat,eval(s:feature_dict[l:feat]))
    else
        for l:key in keys(s:feature_dict)
            if type(eval(l:key)) != g:t_string
                let s:feature_dict[l:key]=a:en
                execute 'let '.l:key.'='.a:en
                call te#feat#feat_enable(l:key,eval(s:feature_dict[l:key]))
            endif
        endfor
        call te#feat#gen_feature_vim()
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
    call te#feat#writefile(l:content, l:tempfile)
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
    if type(l:val)
        execute 'let '.a:var.'='.string(l:val)
        let s:feature_dict[a:var]=string(l:val)
    else
        execute 'let '.a:var.'='.l:val
        let s:feature_dict[a:var]=l:val
    endif
    if !exists(':Plug')
        return
    endif
    if eval(a:var) != 0 && matchstr(a:var, 'g:feat_enable_') !=# ''
        call te#feat#source_rc(matchstr(a:var,'_\zs[^_]*\ze$').'.vim')
    endif
endfunction

let s:plugin_func_list=[]

function! te#feat#register_vim_enter_setting(funcref) abort
    if type(a:funcref) != g:t_func
        call te#utils#EchoWarning('register failed!funcref must be a funcref variable', 'err')
        return -1
    endif
    call add(s:plugin_func_list, a:funcref)
    return 0
endfunction

function! te#feat#run_vim_enter_setting() abort
    for l:Needle in s:plugin_func_list
        call l:Needle()
    endfor
endfunction

function! te#feat#check_plugin_install() abort
    if !get(g:,'enable_auto_plugin_install')
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

"write to file
function! te#feat#writefile(list, fname,...) abort
    if te#env#SupportAsync()
        if a:0 == 1
            call writefile(a:list, a:fname, a:1)
        else
            call writefile(a:list, a:fname)
        endif
    else
        if type(a:list) != g:t_list
            call te#utils#EchoWarning("Not a list", 'err')
            return
        endif
        if type(a:fname) != g:t_string
            call te#utils#EchoWarning("Not a string", 'err')
            return
        endif
        let l:fcontents=[]
        if filereadable(a:fname)
            let l:fcontents=readfile(a:fname, 'b')
            if !empty(l:fcontents) && empty(l:fcontents[-1])
                call remove(l:fcontents, -1)
            endif
        endif
        call writefile(l:fcontents+a:list, a:fname, 'b')
    endif
endfunction
