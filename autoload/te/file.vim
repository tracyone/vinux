
function! te#file#copy_file(src, dst) abort
    let l:confirm = 1
    let l:ret = -1
    if isdirectory(a:dst)
        let l:dst=a:dst.'/'.fnamemodify(a:src, ':t')
    else
        let l:dst=a:dst
    endif

    if filereadable(a:src)
        if filereadable(l:dst)
            if confirm(l:dst." is exist! override?", "&Yes\n&No", 2) == 2
                call te#utils#EchoWarning("Copy file abort")
                let l:confirm = 0
            endif
        endif
        if l:confirm == 1
            if !exists('*readblob')
                let l:ret = system('cp -a '.a:src.' '.l:dst)
            else
                let l:ret = writefile(readblob(a:src), l:dst, "s")
            endif
            if l:ret
                call te#utils#EchoWarning("Copy ".a:src.' to '.l:dst.' fail')
            else
                call te#utils#EchoWarning("Copy ".a:src.' to '.l:dst.' successfully')
            endif
        endif
    else
        call te#utils#EchoWarning(a:src.' is not exists')
    endif
    return l:ret
endfunction

function! te#file#delete(path) abort
    let l:ret = -1
    if (confirm('Delete '.a:path, "&Yes\n&No", 2)==1)
        let l:ret=delete(a:path, 'rf')
    endif
    return l:ret
endfunction
