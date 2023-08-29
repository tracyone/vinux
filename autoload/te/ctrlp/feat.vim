"ctrlp feature
"author:tracyone@live.cn

call add(g:ctrlp_ext_vars, {
      \ 'init': 'te#ctrlp#feat#init()',
      \ 'accept': 'te#ctrlp#feat#accept',
      \ 'lname': 'feature',
      \ 'sname': 'feat',
      \ 'type': 'line',
      \ 'sort': 1,
      \ 'specinput': 0,
      \ })

function! te#ctrlp#feat#init() abort
  return s:text
endfunction

function! s:get_var_value(item) abort
    let l:str = s:var_candidate[a:item - 1]
    let l:feat_dict=te#feat#get_feature_dict()
    let l:feat_dict[s:var_value]=string(l:str)
    execute 'let '.s:var_value.'='.string(l:str)
    call te#feat#gen_feature_vim(0)
    call te#utils#EchoWarning('Set '.s:var_value.' to '.string(l:str).' successfully!', 'info')
endfunction

let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)
"press ctrl-v will not exit ctrlp
function! te#ctrlp#feat#accept(mode, str) abort
    call ctrlp#exit()
    if s:enable_flag == 1
        let l:enable='Enable'
    else
        let l:enable='Disable'
    endif
    let l:feat_dict=te#feat#get_feature_dict()
    if a:str !=# 'all'
        if type(eval(a:str))
            let s:var_candidate=[]
            let l:feat_candidate=eval(matchstr(a:str,'.*\(\.cur_val\)\@=').'.candidate')
            call extend(s:var_candidate,l:feat_candidate)
            let s:var_value = a:str
            call te#utils#confirm('Select '.s:var_value."'s option", s:var_candidate, function('<SID>get_var_value'))
            return
        else
            let l:feat_dict[a:str]=s:enable_flag
            execute 'let '.a:str.'='.s:enable_flag
            call te#feat#gen_feature_vim(0)
            call te#feat#feat_enable(a:str,eval(l:feat_dict[a:str]))
        endif
    else
        for l:key in keys(l:feat_dict)
            if type(eval(l:key)) != g:t_string
                let l:feat_dict[l:key]=s:enable_flag
                execute 'let '.l:key.'='.s:enable_flag
                call te#feat#feat_enable(l:key,eval(l:feat_dict[l:key]))
            endif
        endfor
        call te#feat#gen_feature_vim(0)
    endif
    if s:enable_flag == 1 | :PlugInstall --sync | q | endif
    call te#feat#source_rc('colors.vim')
    call te#utils#EchoWarning(l:enable.' '.a:str.' successfully!')
endfunction

function! te#ctrlp#feat#id() abort
  return s:id
endfunction

function! te#ctrlp#feat#start(en) abort
    let s:text = []
    for l:key in keys(te#feat#get_feature_dict())
        call add(s:text, l:key)
    endfor
    call add(s:text, 'all')
    let s:enable_flag=a:en
    call ctrlp#init(te#ctrlp#feat#id()) 
endfunction
