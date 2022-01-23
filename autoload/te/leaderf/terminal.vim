function! s:open_shell(timer)
    let l:buf = str2nr(s:buf)
    call te#terminal#open_term({'bufnr':l:buf})
endfunction

function! te#leaderf#terminal#accept(line, args) abort
    let s:buf =  matchstr(a:line, '\d\+\(:\)\@=')
    call timer_start(100, function('<SID>open_shell'), {'repeat': 1})
endfunction

function! te#leaderf#terminal#preview(orig_buf_nr, orig_cursor, line, args) abort
    let l:buf_nr =  str2nr(matchstr(a:line, '\d\+\(:\)\@='))
    let l:linenum = te#terminal#get_line(l:buf_nr)
    if l:linenum > 20
        let l:linenum -= 20
    else
        let l:linenum = 0
    endif
    return [l:buf_nr, l:linenum, '']
endfunction

function! te#leaderf#terminal#source(args) abort
    let l:buf_list = te#terminal#get_buf_list()
    let l:result_list = []
    for l:buf in l:buf_list
        call add(l:result_list, l:buf.':'.te#terminal#get_title(l:buf))
    endfor
    return l:result_list
endfunction
