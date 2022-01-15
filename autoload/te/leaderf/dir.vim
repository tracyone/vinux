function! te#leaderf#dir#source(args) abort
    if te#env#IsWindows()
        let l:text = te#compatiable#systemlist('dir /B /D')
        if type(l:text) == g:t_number
            return
        endif
        let l:text_dir=filter(deepcopy(l:text),'isdirectory(v:val)')
        call filter(l:text,'isdirectory(v:val) == 0')
        call map(l:text_dir, 'v:val."\\"')
        call extend(l:text, l:text_dir)
        call add(l:text, '..\')
    else
        let l:text = te#compatiable#systemlist('ls -a -F')
        if type(l:text) == g:t_number
            return
        endif
    endif
    return l:text
endfunction

function! te#leaderf#dir#needExit(line, args) abort
    let l:file_or_dir=matchstr(a:line,".*[^@]")
    if isdirectory(l:file_or_dir)
        return 0
    else
        return 1
    endif
endfunction

function! te#leaderf#dir#preview(orig_buf_nr, orig_cursor, line, args) abort
    if isdirectory(a:line)
        return []
    endif
     let l:buf_nr = bufadd(a:line)
    return [l:buf_nr, 0, '']
endfunction

function! te#leaderf#dir#accept(line, args) abort
    let l:file_or_dir=matchstr(a:line,".*[^@]")
    if isdirectory(l:file_or_dir)
        execute 'cd 'l:file_or_dir
        let source = te#leaderf#dir#source(0)
        norm! ggdG
        call setline(1, source)
    else
        execute 'e '.l:file_or_dir
    endif
endfunction
