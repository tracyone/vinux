
function! te#file#copy_file(src, dst,...) abort
    let l:confirm = 1
    let l:execure_write = 1
    let l:ret = -1
    if isdirectory(a:dst)
        let l:dst=a:dst.'/'.fnamemodify(a:src, ':t')
    else
        let l:dst=a:dst
    endif
    if a:0 == 1
        let l:confirm = a:1
    endif

    if filereadable(a:src) || isdirectory(a:src)
        if filereadable(l:dst)
            if l:confirm == 1
                if confirm(l:dst." is exist! override?", "&Yes\n&No", 2) == 2
                    call te#utils#EchoWarning("Copy file abort")
                    let l:execure_write = 0
                endif
            endif
        endif
        if l:execure_write == 1
            if te#env#Executable('cp')
                call te#utils#run_command('cp -a '.a:src.' '.l:dst)
            else
                let l:ret = writefile(readblob(a:src), l:dst, "s")
                if l:ret
                    call te#utils#EchoWarning("Copy ".a:src.' to '.l:dst.' fail')
                else
                    call te#utils#EchoWarning("Copy ".a:src.' to '.l:dst.' successfully')
                endif
            endif
        endif
    else
        call te#utils#EchoWarning(a:src.' is not exists')
    endif
    return l:ret
endfunction

function! te#file#delete(path, confirm) abort
    let l:ret = -1
    if a:confirm == 0 || (confirm('Delete '.a:path, "&Yes\n&No", 2)==1)
        let l:ret=delete(a:path, 'rf')
    endif
    return l:ret
endfunction