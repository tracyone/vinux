"pop vimshell
function! te#tools#shell_pop() abort
    " 38% height of current window
    let l:line=(38*&lines)/100
    if  l:line < 10 | let l:line = 10 |endif
    let l:fullbuffer=1
    "any list buffer exist or buffer is startify
    if bufexists(expand('%')) && &filetype !=# 'startify'
        let l:fullbuffer=0
        if !te#env#IsVim8()
            execute 'rightbelow '.l:line.'split'
        endif
    endif
    if te#env#SupportTerminal()  && te#env#IsVim8()
        :terminal
        if l:fullbuffer == 1
            execute 'normal '."\<c-w>:only\<cr>"
        else
            execute 'normal '."\<c-w>r"
        endif
    elseif te#env#SupportTerminal() && te#env#IsNvim()
        :terminal
    else 
        execute 'VimShell' 
    endif
endfunction
