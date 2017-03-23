"return vim version infomatrion
"l:result[0]:vim main version
"l:result[1]:vim patch info
function! te#feat#get_vim_version() abort
    redir => l:msg
    silent! execute ':version'
    redir END
    let l:result=[]
    call add(l:result,matchstr(l:msg,'VIM - Vi IMproved\s\zs\d.\d\ze'))
    call add(l:result, matchstr(l:msg, ':\s\d-\zs\d\{1,3\}\ze'))
    return l:result
endfunction

function! te#feat#get_feature(A, L, P) abort
    let l:temp=a:A.a:L.a:P
    if !exists('g:feature_dict')
        return 'GET FEATURE ERROR'
    endif
    let l:result=l:temp 
    let l:result=''
    for l:key in keys(g:feature_dict)
        let l:result.=l:key."\n"
    endfor
    let l:result.='all'."\n"
    return l:result
endfunction

function! te#feat#gen_feature_vim() abort
    call delete($VIMFILES.'/feature.vim')
	for l:key in keys(g:feature_dict)
	   call writefile(['let '.l:key.'='.g:feature_dict[l:key]], $VIMFILES.'/feature.vim', 'a')
	endfor
    let l:t_vim_version=system('git describe')
    if v:shell_error != 0
	    let l:t_vim_version='Unknown'
    else
        let l:temp=te#feat#get_vim_version()
        let l:t_vim_version=split(l:t_vim_version, '\n')[-1].'@'.l:temp[0].'.'.l:temp[1].'(t-vim)'
    endif
    let g:t_vim_version=string(l:t_vim_version)
    call writefile(['let g:t_vim_version='.string(l:t_vim_version)], $VIMFILES.'/feature.vim', 'a')
endfunction

function! te#feat#feat_dyn_enable() abort
    let l:feat = input('Select the feature: ','g:feat_enable_','custom,te#feat#get_feature')
    if l:feat !=# 'all'
        if type(eval(l:feat))
            let l:str=input('Input the value of '.l:feat.': ')
            let g:feature_dict[l:feat]=string(l:str)
            execute 'let '.l:feat.'='.string(l:str)
        else
            let g:feature_dict[l:feat]=1
            execute 'let '.l:feat.'=1'
        endif
        call te#feat#gen_feature_vim()
        call te#feat#feat_enable(l:feat,eval(g:feature_dict[l:feat]))
    else
        for l:key in keys(g:feature_dict)
            if type(eval(l:key)) != v:t_string
                let g:feature_dict[l:key]=1
                execute 'let '.l:key.'=1'
                call te#feat#feat_enable(l:key,eval(g:feature_dict[l:key]))
            endif
        endfor
        call te#feat#gen_feature_vim()
    endif
    :PlugInstall --sync | q
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
    call writefile(l:content, l:tempfile)
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
        let g:feature_dict[a:var]=string(l:val)
    else
        execute 'let '.a:var.'='.l:val
        let g:feature_dict[a:var]=l:val
    endif
  if eval(a:var) != 0 && matchstr(a:var, 'g:feat_enable_') !=# ''
      call te#feat#source_rc(matchstr(a:var,'_\zs[^_]*\ze$').'.vim')
  endif
endfunction

let s:plugin_func_list=[]

function! te#feat#register_vim_enter_setting(funcref) abort
    if type(a:funcref) != v:t_func
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
    if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
        call te#utils#EchoWarning('Install the missing plugins!')
        PlugInstall --sync | q
    endif
endfunction

