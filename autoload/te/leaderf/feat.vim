function! te#leaderf#feat#source(args) abort
    let l:text = []
    for l:key in keys(te#feat#get_feature_dict())
        call add(l:text, l:key)
    endfor
    call add(l:text, 'all')
    return l:text
endfunction

function! s:get_var_value(item) abort
    let l:str = s:var_candidate[a:item - 1]
    let l:feat_dict=te#feat#get_feature_dict()
    let l:feat_dict[s:var_value]=string(l:str)
    execute 'let '.s:var_value.'='.string(l:str)
    call te#feat#gen_feature_vim(0)
    call te#utils#EchoWarning('Set '.s:var_value.' to '.string(l:str).' successfully!', 'info')
endfunction

function! te#leaderf#feat#accept(line, args) abort
    "{'popup_winid': 1002, '-d': [], 'arg_line': ' feat -d ', 'win_pos': 'popup'}
    if a:args['-d'] == ['1']
        let l:en_flag = 1
    else
        let l:en_flag = 0
    endif
    if l:en_flag == 1
        let l:enable='Enable'
    else
        let l:enable='Disable'
    endif
    let l:feat_dict=te#feat#get_feature_dict()
    if a:line !=# 'all'
        if type(eval(a:line))
            let s:var_candidate=[]
            let l:feat_candidate=eval(matchstr(a:line,'.*\(\.cur_val\)\@=').'.candidate')
            call extend(s:var_candidate,l:feat_candidate)
            let s:var_value=a:line
            call te#utils#confirm('Select '.a:line."'s option", s:var_candidate, function('<SID>get_var_value'))
            return
        else
            let l:feat_dict[a:line]=l:en_flag
            execute 'let '.a:line.'='.l:en_flag
            call te#feat#gen_feature_vim(0)
            call te#feat#feat_enable(a:line,eval(l:feat_dict[a:line]))
        endif
    else
        for l:key in keys(l:feat_dict)
            if type(eval(l:key)) != g:t_string
                let l:feat_dict[l:key]=l:en_flag
                execute 'let '.l:key.'='.l:en_flag
                call te#feat#feat_enable(l:key,eval(l:feat_dict[l:key]))
            endif
        endfor
        call te#feat#gen_feature_vim(0)
    endif
    if l:en_flag == 1 | :PlugInstall --sync | q | endif
    call te#feat#source_rc('colors.vim')
    call te#utils#EchoWarning(l:enable.' '.a:line.' successfully!')
endfunction


