
function! s:copy_action(src, dst) abort
    let l:ret = 0
    if te#env#Executable('cp')
        call te#utils#run_command('cp -a '.a:src.' '.a:dst)
    else
        let l:ret = writefile(readblob(a:src), a:dst, "s")
        if l:ret
            call te#utils#EchoWarning("Copy ".a:src.' to '.a:dst.' fail')
        endif
    endif
    return l:ret
endfunction

function! te#file#copy_file(src, dst,...) abort
    let l:confirm = 1
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
                let l:dict = {}
                let l:dict.func = function("<SID>copy_action")
                let l:dict.arg = [a:src, l:dst]
                "confirm before copy
                let l:ret = te#utils#confirm(l:dst." is exist! override?", ['Yes', 'No'], [l:dict, ""])
            else
                "copy without confirm
                let l:ret = <SID>copy_action(a:src, l:dst)
            endif
        else
            "Everything is fine. Just copy.
            let l:ret = <SID>copy_action(a:src, l:dst)
        endif
    else
        call te#utils#EchoWarning(a:src.' is not exists')
    endif
    return l:ret
endfunction

function! te#file#delete(path, confirm) abort
    let l:ret = -1
    if a:confirm == 1
        let l:ret = te#utils#confirm('Delete '.a:path, ['Yes', 'No'], ["call delete(".string(a:path).", 'rf')", ""])
    else
        let l:ret = delete(a:path, 'rf')
    endif
    return l:ret
endfunction
