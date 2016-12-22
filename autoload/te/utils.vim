
" name :s:TracyoneGetError
" arg  :command,vim command(not shell command) that want to
"       test execute status
" arg   : err_str,error substring pattern that is expected
" return:return 0 if no error exist,return -1 else
function! te#utils#GetError(command,err_str)
    redir => l:msg
    silent! execute a:command
    redir END
    let l:rs=split(l:msg,'\r\n\|\n')
    if get(l:rs,-1,3) ==3  "no error exists
        return 0
    elseif l:rs[-1] =~# a:err_str
        return -1
    else
        return 0
    endif
endfunction


"echo warning messag
func! te#utils#EchoWarning(str)
    redraw!
    echohl WarningMsg | echo a:str | echohl None
endfunc


" save files in every condition
function! te#utils#SaveFiles()
    try 
        update
    catch /^Vim\%((\a\+)\)\=:E212/
        if exists(":SudoWrite")
            call te#utils#EchoWarning("sudo write,please input your password!")
            SudoWrite %
            return 0
        else
            :w !sudo tee %
        endif
    catch /^Vim\%((\a\+)\)\=:E32/   "no file name
        if s:is_gui
            exec ":emenu File.Save"
            return 0
        endif
        let l:filename=input("NO FILE NAME!Please input the file name: ")
        if l:filename == ""
            call te#utils#EchoWarning("You just give a empty name!")
            return 3
        endif
        try 
            exec "w ".l:filename
        catch /^Vim\%((\a\+)\)\=:E212/
            call te#utils#EchoWarning("sudo write,please input your password!")
            if exists(":SudoWrite")
                SudoWrite %
                return 0
            else
                :w !sudo tee %
            endif
        endtry
    endtry
endfunction
