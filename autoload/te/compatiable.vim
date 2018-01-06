
"te#compatiable#writefile
"write to file
function! te#compatiable#writefile(list, fname,...) abort
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

"systemlist compatiable function.
function! te#compatiable#systemlist(expr, ...)
    if exists('*systemlist') && !te#env#IsWindows()
        if a:0 == 1
            return systemlist(a:expr, a:1)
        else
            return systemlist(a:expr)
        endif
    else
        if a:0 == 1
            return split(system(a:expr, a:1),nr2char(10))
        else
            return split(system(a:expr),nr2char(10))
        endif
    endif
endfunction
