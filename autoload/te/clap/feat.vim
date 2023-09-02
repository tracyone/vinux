"Clap feature for vinux
"author:<tracyone tracyone@live.cn>

let s:text = []
let s:enable_flag= 0
let s:var_value=""

function! s:get_var_value(item) abort
    let l:str = s:var_candidate[a:item - 1]
    let l:feat_dict=te#feat#get_feature_dict()
    let l:feat_dict[s:var_value]=string(l:str)
    execute 'let '.s:var_value.'='.string(l:str)
    call te#feat#gen_feature_vim(0)
    call te#utils#EchoWarning('Set '.s:var_value.' to '.string(l:str).' successfully!', 'info')
endfunction

function! s:edit_file(item)
    let l:str = a:item
    if s:enable_flag == 1
        let l:enable='Enable'
    else
        let l:enable='Disable'
    endif
    let l:feat_dict=te#feat#get_feature_dict()
    if l:str !=# 'all'
        if type(eval(l:str))
            let s:var_candidate=[]
            let l:feat_candidate=eval(matchstr(l:str,'.*\(\.cur_val\)\@=').'.candidate')
            call extend(s:var_candidate,l:feat_candidate)
            let s:var_value=l:str
            call te#utils#confirm('Select '.s:var_value."'s option", s:var_candidate, function('<SID>get_var_value'))
            return
        else
            let l:feat_dict[l:str]=s:enable_flag
            execute 'let '.l:str.'='.s:enable_flag
            call te#feat#gen_feature_vim(0)
            call te#feat#feat_enable(l:str,eval(l:feat_dict[l:str]))
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
    call te#utils#EchoWarning(l:enable.' '.l:str.' successfully!', 'info')
endfunction

function! te#clap#feat#start(en) abort
    let s:text = []
    for l:key in keys(te#feat#get_feature_dict())
        call add(s:text, l:key)
    endfor
    call add(s:text, 'all')
    let s:enable_flag=a:en
    if a:en == 1
        let l:id = 'feat_en'
    else
        let l:id = 'feat_dis'
    endif
    let l:run_dict = {
                    \ 'source': s:text, 
                    \ 'sink': function('<SID>edit_file'),
                    \ 'id': l:id,
                    \ }
    if !exists('g:clap')
        call clap#init#()
    endif
    call clap#run(l:run_dict)
endfunction
