function! te#leaderf#feat#source(args) abort
    let l:text = []
    for l:key in keys(te#feat#get_feature_dict())
        call add(l:text, l:key)
    endfor
    call add(l:text, 'all')
    return l:text
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
    call te#feat#feature_enable(l:en_flag, a:line)
endfunction


